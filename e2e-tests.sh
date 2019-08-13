#!/usr/bin/env bash

export POSTGRES_USER=circleci
export POSTGRES_DB=mappamundi_dev
export POSTGRES_PASSWORD=""
export DB_DATABASE=mappamundi_dev
export DB_ADDR=db
export DB_USER=circleci
export DATABASE_NAME=mappamundi_dev
export DATABASE_USERNAME=circleci
export DATABASE_PASSWORD=""
export DATABASE_HOST=db
export HAVEN_JWK_PATH=/keycloak-dev-public-key.json
export KEYCLOAK_USER=admin
export KEYCLOAK_PASSWORD=admin
export PROXY_ADDRESS_FORWARDING="true"
export FLYWAY_URL="jdbc:postgresql://db/mappamundi_dev"
export FLYWAY_USER=circleci
export FLYWAY_IGNORE_MISSING_MIGRATIONS="true"
export FLYWAY_GROUP="true"
export FLYWAY_SCHEMAS=mappa,1
export HAVEN_JWK_PATH=/cfg/keycloak-dev-public-key.json
export HAVEN_JWT_ISS=http://keycloak:8080/auth/realms/havendev
export TEST_DATABASE_URL="postgres://circleci@db:5432/mappamundi_test?sslmode=disable"
export API_SERVER=havenapi:3000
export AUTH_SERVER=keycloak:8080
export BUFFALO_SERVER=havenapi:3000
export DISCOVERY_URL=http://webui/auth/realms/havendev
export UPSTREAM_URL=http://webui/
export GATEKEEPER_SESSION_KEY="c01f3736e640ea874d66c3704ddb7a9a"
export SECURE_COOKIE="false"
export GATEKEEPER_LISTEN_PORT="81"
export REDIRECTION_URL=http://dev.havengrc.com/
export KEYCLOAK_INTERNAL=http://keycloak:8080
export KEYCLOAK_SCHEME=http
export DISCOVERY_URL=http://dev.havengrc.com/auth/realms/havendev
export BASE_URI=""
export GATEKEEPER_INTERNAL=http://gatekeeper:81
export CLIENT_SECRET="df2ba720-1d10-4d85-940a-6df77ef69baa"
export GO_ENV=production

source ./report-changed-services
# create network for containers
docker network create -d bridge net0
# run db
docker run --network net0 -d -e POSTGRES_USER -e POSTGRES_DB -e POSTGRES_PASSWORD -h db --name db circleci/postgres:9.6.4-alpine
# wait for DB
docker run --network net0 --name dockerize1 jwilder/dockerize -wait tcp://db:5432 -timeout 1m
sleep 2
docker run --network net0 --name psql circleci/postgres:9.6.4-alpine /usr/local/bin/psql -l -h db -U circleci || true
# create dummy DB to work around https://github.com/markbates/pop/issues/175
docker run --network net0 --name createdb circleci/postgres:9.6.4-alpine /usr/local/bin/createdb -h db -U circleci circleci
# run mailhog
docker run --network net0 -d -h mailhog --name mailhog mailhog/mailhog:v1.0.0
# wait for mailhog
docker run --network net0 --name dockerize2 jwilder/dockerize  -wait tcp://mailhog:8025 -timeout 2m
# creating dummy container which will hold a volume with config
docker create -v /cfg -v /keycloak --name configs alpine:3.4 /bin/true
docker cp keycloak/keycloak-dev-public-key.json configs:/cfg
docker cp keycloak/data/havendev-realm.json configs:/keycloak
docker pull kindlyops/keycloak:$KEYCLOAK_REV
# start keycloak in background container
docker run --volumes-from configs --network net0 -d -e DB_DATABASE -e DB_USER -e DB_ADDR -e KEYCLOAK_USER -e KEYCLOAK_PASSWORD -e PROXY_ADDRESS_FORWARDING -h keycloak --name keycloak kindlyops/keycloak:$KEYCLOAK_REV -b 0.0.0.0 -Dkeycloak.migration.file=/keycloak/havendev-realm.json -Dkeycloak.migration.strategy=IGNORE_EXISTING -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.action=import
# Wait for keycloak
docker run --network net0 --name dockerize3 jwilder/dockerize  -wait tcp://keycloak:8080 -timeout 2m
docker pull kindlyops/havenflyway:$FLYWAY_REV
docker run --network net0 --name flyway -e FLYWAY_URL -e FLYWAY_USER -e FLYWAY_IGNORE_MISSING_MIGRATIONS -e FLYWAY_GROUP -e FLYWAY_SCHEMAS kindlyops/havenflyway:$FLYWAY_REV migrate -placeholders.databaseUser=circleci
docker build -t kindlyops/havenapitest -f havenapi/Dockerfile-hotreload .
docker pull kindlyops/havenapi:$HAVENAPI_REV
docker build -t kindlyops/apitest -f apitest/Dockerfile .
docker run --volumes-from configs --network net0 --name buffalotest -e KC_ADMIN=admin -e KC_PW=admin -e KC_HOST=http://keycloak -e KC_PORT=8080 -e TEST_DATABASE_URL -e HAVEN_JWK_PATH -e HAVEN_JWT_ISS kindlyops/havenapitest /go/bin/buffalo test
docker run --volumes-from configs --network net0 -d -h havenapi --name havenapi -e KC_ADMIN=admin -e KC_PW=admin -e KC_HOST=http://keycloak -e KC_PORT=8080 -e TEST_DATABASE_URL -e HAVEN_JWK_PATH -e HAVEN_JWT_ISS kindlyops/havenapitest /go/bin/buffalo dev
docker run --network net0 --name dockerize5 jwilder/dockerize  -wait tcp://havenapi:3000 -timeout 2m
docker run --volumes-from configs --name cucumber --network net0 -e API_SERVER -e AUTH_SERVER -e BUFFALO_SERVER --workdir /usr/src/app kindlyops/apitest cucumber
echo $WEBUI_TEST_CERT|base64 --decode - > fullchain.pem
echo $WEBUI_TEST_KEY|base64 --decode - > privkey.pem
# creating dummy container which will hold a volume with certs
docker create -v /certs --name certs alpine:3.4 /bin/true
docker cp fullchain.pem certs:/certs
rm fullchain.pem
docker cp privkey.pem certs:/certs
rm privkey.pem
docker pull kindlyops/havenweb:$WEBUI_REV
docker run -d --volumes-from certs --network net0 -h webui --name webui -e ELM_APP_KEYCLOAK_CLIENT_ID=havendev kindlyops/havenweb:$WEBUI_REV
docker pull kindlyops/gatekeeper:$GATEKEEPER_REV
docker run -d --volumes-from certs --network net0 --publish 80:81 --name gatekeeper -e DISCOVERY_URL -e UPSTREAM_URL -e REDIRECTION_URL -e GATEKEEPER_LISTEN_PORT -e SECURE_COOKIE -e GATEKEEPER_SESSION_KEY -e KEYCLOAK_INTERNAL -e KEYCLOAK_SCHEME -e DISCOVERY_URL -e BASE_URI -e CLIENT_SECRET kindlyops/gatekeeper:$GATEKEEPER_REV
docker build -t kindlyops/cypress -f webui/Dockerfile-cypress ./webui
# creating dummy container to hold volume with outputs from cypress
docker create -v /e2e/cypress/videos/ --name videos alpine:3.4 /bin/true
docker run --network net0 --name cypress -e GATEKEEPER_INTERNAL --volumes-from videos kindlyops/cypress run
