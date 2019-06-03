#!/bin/bash

set -x

# we proxy to the webpack hotreload dev server via caddy
exec vendor/linux/caddy -agree -conf /code/Caddyfile-dev
