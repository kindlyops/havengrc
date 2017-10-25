# building caddy from source

We build caddy ourselves from source because we want
the Apache 2 licensed version, not the non-free EULA
covered binary version distributed from the caddy website.

    go get github.com/mholt/caddy/caddy
    cd $GOPATH/src/github.com/mholt/caddy/caddy
    go get github.com/caddyserver/builds -goos=linux
