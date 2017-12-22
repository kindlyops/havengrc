package actions

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"strings"

	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/buffalo/middleware"
	"github.com/gobuffalo/buffalo/middleware/ssl"
	"github.com/gobuffalo/envy"
	"github.com/gobuffalo/x/sessions"
	"github.com/unrolled/secure"
	jose "gopkg.in/square/go-jose.v2"
	jwt "gopkg.in/square/go-jose.v2/jwt"

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
		allClaims := make(map[string]interface{})
		if err := tok.Claims(key, &allClaims); err != nil {
			return c.Error(http.StatusUnauthorized, err)
		}
		fmt.Printf("claims: %+v\n", allClaims)

		// TODO: check if token is expired

		// TODO: set user, email, sub in buffalog request context
		//c.Set("user", u)

		email := allClaims["email"]
		sub := allClaims["sub"]
		err = models.DB.RawQuery(models.Q["setemailclaim"], email).Exec()
		if err != nil {
			return c.Error(500, fmt.Errorf("error setting JWT claims in GUC: %s", err.Error()))
		}
		err = models.DB.RawQuery(models.Q["setsubclaim"], sub).Exec()
		if err != nil {
			return c.Error(500, fmt.Errorf("error setting JWT claims in GUC: %s", err.Error()))
		}

		return next(c)
	}
}
