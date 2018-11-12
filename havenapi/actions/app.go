package actions

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"strings"

	"github.com/deis/helm/log"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/buffalo/middleware"
	"github.com/gobuffalo/buffalo/middleware/ssl"
	"github.com/gobuffalo/envy"
	"github.com/gobuffalo/pop"
	"github.com/gobuffalo/x/sessions"
	"github.com/rs/cors"
	"github.com/unrolled/secure"
	jose "gopkg.in/square/go-jose.v2"
	jwt "gopkg.in/square/go-jose.v2/jwt"

	"github.com/kindlyops/havengrc/havenapi/models"
)

// ENV is used to help switch settings based on where the
// application is being run. Default is "development".
var ENV = envy.Get("GO_ENV", "development")

// KEY gets the haven jwk path
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
			PreWares: []buffalo.PreWare{
				cors.Default().Handler,
			},
			SessionName: "_havenapi_session",
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
		api.Middleware.Skip(JwtMiddleware, RegistrationHandler)
		api.POST("files", UploadHandler)
		api.POST("registration_funnel", RegistrationHandler)

	}

	return app
}

// Token is for un marshalling {"resource_access":{"havendev":{"roles":["member"]}}
type Token struct {
	ResourceAccess struct {
		Client struct {
			Roles []string `json:"roles,omitempty"`
		} `json:"havendev,omitempty"`
	} `json:"resource_access,omitempty"`
}

func getRole(allClaims map[string]interface{}) string {
	// look for the role that we should assume
	// {"resource_access":{"havendev":{"roles":["member"]}}
	access := allClaims["resource_access"].(map[string]interface{})
	havendev := access["havendev"].(map[string]interface{})
	roles := havendev["roles"].([]interface{})
	var role string
	for _, r := range roles {
		switch r.(string) {
		case "member":
			role = "member"
		case "admin":
			role = "admin"
		default:
			log.Info("Got unexpected role %s", r)
			role = "anonymous"
		}
	}
	return role
}

// JwtMiddleware validates JWT and set context compatible with PostgREST
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

		org := allClaims["org"]
		c.Set("org", org)
		enc, _ := json.Marshal(org)

		role := getRole(allClaims)

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
			return c.Error(500, fmt.Errorf("error setting JWT claims sub in GUC: %s", err.Error()))
		}

		err = tx.RawQuery(models.Q["setorgclaim"], string(enc)).Exec()
		if err != nil {
			return c.Error(500, fmt.Errorf("error setting JWT claims org in GUC: %s", err.Error()))
		}

		err = tx.RawQuery(models.Q["setrole"], role).Exec()
		if err != nil {
			return c.Error(500, fmt.Errorf("error setting PostgreSQL role: %s", err.Error()))
		}

		return next(c)
	}
}
