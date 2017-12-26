package actions

import (
	"fmt"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/buffalo/middleware"
	"github.com/gobuffalo/buffalo/middleware/ssl"
	"github.com/gobuffalo/envy"
	"github.com/gobuffalo/x/sessions"
	"github.com/markbates/pop"
	"github.com/unrolled/secure"
	jose "gopkg.in/square/go-jose.v2"
	jwt "gopkg.in/square/go-jose.v2/jwt"
	"io/ioutil"
	"net/http"
	"strings"

	"github.com/kindlyops/mappamundi/havenapi/models"
)

// ENV is used to help switch settings based on where the
// application is being run. Default is "development".
var ENV = envy.Get("GO_ENV", "development")

// TODO mappamundi/postgrest/keycloak-dev-public-key.json should be
// the JWK and will need to be mounted into the havenapi container
var KEY = envy.Get("HAVEN_JWK_PATH", "")

var key jose.JSONWebKey
var app *buffalo.App

// App is where all routes and middleware for buffalo
// should be defined. This is the nerve center of your
// application.
func App() *buffalo.App {
	if app == nil {
		app = buffalo.New(buffalo.Options{
			Env:          ENV,
			SessionStore: sessions.Null{},
			SessionName:  "_havenapi_session",
		})

		rawKey, err := ioutil.ReadFile(KEY)
		if err != nil {
			panic("could not read the JWK")
		}

		err = key.UnmarshalJSON(rawKey)
		if err != nil {
			panic("could not unmarshal the JWK")
		}

		if ENV == "development" {
			app.Use(middleware.ParameterLogger)
		}

		app.GET("/healthz", HealthzHandler)

		api := app.Group("/api/")
		// Automatically redirect to SSL
		api.Use(ssl.ForceSSL(secure.Options{
			SSLRedirect:     ENV == "production",
			SSLProxyHeaders: map[string]string{"X-Forwarded-Proto": "https"},
		}))
		// TODO refactor to use dependency injection instead of a package global
		api.Use(middleware.PopTransaction(models.DB))
		api.Use(JwtMiddleware)
		api.POST("files", UploadHandler)

	}

	return app
}

// validate JWT and set context compatible with PostgREST
func JwtMiddleware(next buffalo.Handler) buffalo.Handler {
	return func(c buffalo.Context) error {
		header := c.Request().Header.Get("Authorization")
		parts := strings.Split(header, "Bearer ")

		if len(parts) < 2 {
			return c.Error(http.StatusUnauthorized, fmt.Errorf("Must provide Authorization token"))
		}

		token := parts[1]
		if len(token) == 0 {
			return c.Error(http.StatusUnauthorized, fmt.Errorf("Must provide Authorization token"))
		}

		tok, err := jwt.ParseSigned(token)
		if err != nil {
			return c.Error(http.StatusUnauthorized, err)
		}

		// build up a set of claims to set locally in DB transaction
		// at a minimum set 'request.jwt.claim.email' and 'request.jwt.claim.sub'
		validClaims := jwt.Claims{}
		allClaims := make(map[string]interface{})
		if err := tok.Claims(key, &validClaims, &allClaims); err != nil {
			return c.Error(http.StatusUnauthorized, err)
		}

		// check if token is expired and from a valid issuer
		// TODO: the issuer needs to be configurable to handle on-prem deployments
		iss := "http://localhost:2015/auth/realms/havendev"
		err = validClaims.Validate(jwt.Expected{Issuer: iss})
		if err != nil {
			return c.Error(401, fmt.Errorf("invalid token: %s", err.Error()))
		}

		sub := allClaims["sub"]
		c.Set("sub", sub)

		email := allClaims["email"]
		c.Set("email", email)

		tx := c.Value("tx").(*pop.Connection)
		err = tx.RawQuery(models.Q["setemailclaim"], email).Exec()
		if err != nil {
			return c.Error(500, fmt.Errorf("error setting JWT claims email in GUC: %s", err.Error()))
		}

		err = tx.RawQuery("set local search_path to mappa, public").Exec()
		if err != nil {
			return c.Error(500, fmt.Errorf("Database error setting search path: %s", err.Error()))
		}

		err = tx.RawQuery(models.Q["setsubclaim"], sub).Exec()
		if err != nil {
			return c.Error(500, fmt.Errorf("error setting JWT claims in GUC: %s", err.Error()))
		}

		return next(c)
	}
}
