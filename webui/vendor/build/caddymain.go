package main

import (
	"github.com/mholt/caddy/caddy/caddymain"
	// plug in plugins here, for example:
	// _ "github.com/BTBurke/caddy-jwt"
	// _ "github.com/caddyserver/dnsproviders/route53"
	_ "github.com/caddyserver/forwardproxy"
	_ "github.com/captncraig/cors/caddy"
)

func main() {
	// optional: disable telemetry
	// caddymain.EnableTelemetry = false
	caddymain.Run()
}
