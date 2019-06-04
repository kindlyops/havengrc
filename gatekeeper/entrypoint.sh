#!/bin/sh

set -x

# Run caddy forward proxy for openID discovery in background
/usr/local/bin/dockerize -template /opt/Caddyfile.tmpl:/opt/Caddyfile
/opt/caddy -agree&

/usr/local/bin/dockerize -wait $KEYCLOAK_INTERNAL -timeout 60s
/usr/local/bin/dockerize -wait $DISCOVERY_URL

curl -k -i $DISCOVERY_URL

# wait for keycloak to be available and then template the config file
exec /usr/local/bin/dockerize -template /opt/config/gatekeeper.tmpl:/opt/gatekeeper.yaml /opt/keycloak-gatekeeper --config /opt/gatekeeper.yaml