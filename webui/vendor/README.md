# building caddy from source

We build caddy ourselves from source because we want the Apache 2 licensed version, not the non-free EULA covered binary version distributed from the caddy website.

We need the cors plugin

    go get github.com/mholt/caddy/caddy
    go get github.com/caddyserver/caddyext
    # also any caddy plugins that you want to add
    caddyext install cors
    cd $GOPATH/src/github.com/mholt/caddy/caddy
    # edit caddymain/run.go and add _ "github.com/captncraig/cors/caddy"

    go run build.go -goos=linux -goarch=amd64
