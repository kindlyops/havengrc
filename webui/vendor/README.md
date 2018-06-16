# building caddy from source

We build caddy ourselves from source because we want
the Apache 2 licensed version, not the non-free EULA
covered binary version distributed from the caddy website.


    go get github.com/mholt/caddy/caddy
    # also go get any caddy plugins that you want to add
    cd $GOPATH/src/github.com/mholt/caddy/caddy
    # edit caddymain/run.go and add _ "github.com/caddyserver/someplugin"
    go run build.go -goos=linux -goarch=amd64
