#!/bin/sh

set -x

# get hostname of keycloak auth server
KEYCLOAK=$(echo "$DISCOVERY_URL" | awk -F/ '{print $3}')

# wait for keycloak to be available and then template the config file
exec /usr/local/bin/dockerize -wait http://$KEYCLOAK -timeout 60s -template /opt/config/gatekeeper.tmpl:/opt/gatekeeper.yaml /opt/keycloak-gatekeeper --config /opt/gatekeeper.yaml --verbose