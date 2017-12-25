package actions

import (
	"fmt"
	"github.com/deis/helm/log"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/buffalo/middleware"
	"github.com/gobuffalo/buffalo/middleware/ssl"
	"github.com/gobuffalo/envy"
	"github.com/gobuffalo/x/sessions"
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
		// Automatically redirect to SSL
		app.Use(ssl.ForceSSL(secure.Options{
			SSLRedirect:     ENV == "production",
			SSLProxyHeaders: map[string]string{"X-Forwarded-Proto": "https"},
		}))

		// TODO refactor to use dependency injection instead of a package global
		app.Use(middleware.PopTransaction(models.DB))

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

		app.GET("/", HomeHandler)
		api := app.Group("/api/")
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
		fmt.Printf("claims: %+v\n", allClaims)

		// check if token is expired and from a valid issuer
		// TODO: the issuer needs to be configurable to handle on-prem deployments
		iss := "http://localhost:2015/auth/realms/havendev"
		err = validClaims.Validate(jwt.Expected{Issuer: iss})
		if err != nil {
			return c.Error(401, fmt.Errorf("invalid token: %s", err.Error()))
		}

		// TODO: set user, email, sub in buffalo request context
		//c.Set("user", u)
		sub := allClaims["sub"]
		log.Info("The sub in the token was: %s", sub)
		email := allClaims["email"]
		err = models.DB.RawQuery(models.Q["setemailclaim"], email).Exec()
		if err != nil {
			return c.Error(500, fmt.Errorf("error setting JWT claims in GUC: %s", err.Error()))
		}
		// TODO: figure out why when we set this GUC that it causes an error from pq in the triger
		// 'error inserting file to database: pq: invalid input syntax for uuid: ""'
		// select set_config('request.jwt.claim.sub', $1, true);
		err = models.DB.RawQuery("set search_path to mappa, public").Exec()
		if err != nil {
			return c.Error(500, fmt.Errorf("Database error: %s", err.Error()))
		}
		// SET LOCAL 'request.jwt.claim.sub' = $1;
		err = models.DB.RawQuery("select set_config('request.jwt.claim.sub', $1, true);", sub).Exec()
		if err != nil {
			return c.Error(500, fmt.Errorf("error setting JWT claims in GUC: %s", err.Error()))
		}

		var newsub string
		err = models.DB.Store.Get(&newsub, "select current_setting('request.jwt.claim.sub', true);")
		if err != nil {
			return c.Error(500, fmt.Errorf("error reading JWT claims in GUC: %s", err.Error()))
		}
		log.Info("The sub after reading it back was: '%s'", newsub)

		return next(c)
	}
}
