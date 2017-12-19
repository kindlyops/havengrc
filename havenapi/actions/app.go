package actions

import (
	"fmt"
	"io/ioutil"
	"net/http"

	"github.com/deis/helm/log"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/buffalo/middleware"
	"github.com/gobuffalo/buffalo/middleware/ssl"
	"github.com/gobuffalo/envy"
	"github.com/gobuffalo/x/sessions"
	"github.com/unrolled/secure"

	"gopkg.in/square/go-jose.v1"
)

// ENV is used to help switch settings based on where the
// application is being run. Default is "development".
var ENV = envy.Get("GO_ENV", "development")

// TODO mappamundi/postgrest/keycloak-dev-public-key.json should be
// the JWK and will need to be mounted into the havenapi container
var KEY = envy.Get("HAVEN_JWK_PATH", "")

var key *jose.JsonWebKey
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

		// Set the request content type to JSON
		//app.Use(middleware.SetContentType("application/json"))

		rawKey, err := ioutil.ReadFile(KEY)
		if err != nil {
			panic("could not read the JWK")
		}
		log.Info("Loaded JWK: %s", rawKey)
		// https://godoc.org/gopkg.in/square/go-jose.v1#JsonWebKey.UnmarshalJSON
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
		token := c.Request().Header.Get("Authorization")

		if len(token) <= len("Bearer SOMETOKEN") {
			return c.Error(http.StatusUnauthorized, fmt.Errorf("Must provide Authorization token"))
		}
		log.Info("Authorization token is '%s'", token)

		//c.Set("user", u)

		return c.Error(http.StatusUnauthorized, fmt.Errorf("Failed to validate token"))

		//return next(c)
	}
}
