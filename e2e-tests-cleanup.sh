#!/usr/bin/env bash

# stop and remove containers, volumes, networks.
# this is a separate command so we can inspect inbetween states

docker rm createdb
docker rm psql

docker stop mailhog
docker rm mailhog

docker stop keycloak
docker rm keycloak

docker rm flyway
docker stop api
docker rm api

docker rm buffalotest

docker stop havenapi
docker rm havenapi

docker rm cucumber

docker stop gatekeeper
docker rm gatekeeper

docker stop webui
docker rm webui

docker rm cypress

docker stop db
docker rm db

docker rm configs
docker rm videos 
docker rm certs

docker rm dockerize1
docker rm dockerize2
docker rm dockerize3
docker rm dockerize4
docker rm dockerize5

docker network prune -f
docker volume prune -f