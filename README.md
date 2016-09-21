# Mappa Mundi
[![CircleCI](https://circleci.com/gh/kindlyops/mappamundi.svg?style=svg)](https://circleci.com/gh/kindlyops/mappamundi)

The Controls Mapping service for Compliance Ops.

This exposes a data model using [PostgREST](http://postgrest.com/).

## run the service

The db schema and migrations are managed using sqitch.
The postgresql server, the postgrest API server, and the sqitch tool
are all run from docker containers to reduce the need for
local toolchain installation (perl, haskell, postgresql)

To check and see if you have docker available and set up

    docker -v
    docker-compose -v
    docker info

If you don't have docker running, use the instructions at https://docs.docker.com/docker-for-mac/.
At the time of writing, this is working fine with docker 1.12.

Once you have docker set up:

    docker-compose run --entrypoint="psql -h db -U postgres -c 'CREATE DATABASE mappamundi_dev'" sqitch
    docker-compose run sqitch deploy
    docker-compose up
    curl -s http://localhost:3000/ | jq

## add a database migration

    docker-compose run sqitch add foo -n "Add the foo table"

Edit deploy/foo.sql

```SQL
BEGIN;

CREATE TABLE mappa.foo
(
  name text NOT NULL PRIMARY KEY
);

COMMIT;
```

Edit revert/foo.sql

```SQL
BEGIN;

DROP TABLE mappa.foo CASCADE;

COMMIT;
```

    docker-compose run sqitch deploy # applies changes
    docker-compose run sqitch revert # reverts changes
    # repeat until satisfied
    git add .
    git commit -m "Adding foo table"

## look around inside the database

The psql client is installed in the sqitch image, and can connect
to the DB server running in the database image.

    docker-compose run --entrypoint="psql -h db -U postgres" sqitch
    \l                          # list databases in this server
    \connect mappamundi_dev     # connect to a database
    \dn                         # show the schemas
    \dt                         # show the tables
    SELECT * from foo LIMIT 1;  # run arbitrary queries
    \q                          # disconnect

## Use REST client to interact with the API

[Postman](https://www.getpostman.com/) is a free GUI REST client that makes exploration easy. Run postman, and import a couple of predefined
requests from the collection at postman/*.json.

## More info on postgrest

A tutorial is available here. http://blog.jonharrington.org/postgrest-introduction/
