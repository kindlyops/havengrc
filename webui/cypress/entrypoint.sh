#!/bin/sh

set -x

# Run caddy forward proxy for transparently handling port forwarding
/usr/local/bin/dockerize -template /opt/Caddyfile.tmpl:/opt/Caddyfile
/opt/caddy -conf /opt/Caddyfile -agree&

/usr/local/bin/dockerize -wait $GATEKEEPER_INTERNAL -timeout 60s

exec cypress run

