#!/bin/bash

set -x

npm install
node_modules/bower/bin/bower install --allow-root
# we proxy to the webpack hotreload dev server via caddy
vendor/linux/caddy -agree -conf /code/Caddyfile-dev
