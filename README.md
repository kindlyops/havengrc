# Mappa Mundi
[![CircleCI](https://circleci.com/gh/kindlyops/mappamundi.svg?style=svg)](https://circleci.com/gh/kindlyops/mappamundi)
[![experimental](http://badges.github.io/stability-badges/dist/experimental.svg)](http://github.com/badges/stability-badges)
[![Say Thanks!](https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg)](https://saythanks.io/to/statik)
Haven GRC is a modern risk & compliance dashboard for the cloud.

This exposes a data model using [PostgREST](http://postgrest.com/).

Web front end is in web/

## Learning Elm

Why use Elm? Elm is both a framework and a language. Here is an excellent 16
minute video by Richard Feldman that explains the framework architecture choices
that Elm makes compared to jQuery and Flux. [From jQuery to Flux to Elm](https://www.youtube.com/watch?v=NgwQHGqIMbw).

Elm is also a language that compiles to javascript. Here are some resources for
learning Elm. In particular, the DailyDrip course is quite good, and provides
several wonderful example applications that are MIT licensed and have been used
to help bootstrap this application. You should subscribe to DailyDrip and support
their work.

 * Free elm course http://courses.knowthen.com/p/elm-for-beginners
 * Daily Drip elm course that sends you a little bit of code each day to work on https://www.dailydrip.com/topics/elm
 * Pragmatic Programmers course https://pragmaticstudio.com/elm
 * Frontend Masters 2-day elm workshop https://frontendmasters.com/workshops/elm/

### Design framework and tooling.

We are making use of the [Material Design](https://material.io/guidelines/)
system as a base for our design. We are also using Web Components,
specifically the [PolymerElements](https://www.webcomponents.org/author/PolymerElements)
collections which are implementations of common elements that follow Material Design.

Within the app we are using [SASS](http://sass-lang.com/), and the guidance from
[Inverted Triangle CSS](https://www.xfive.co/blog/itcss-scalable-maintainable-css-architecture/)
and [Reasonable CSS](http://rscss.io/) to try and keep the CSS manageable.

## setting up the dev environment

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

#### Windows users:
Before you continue, you need to configure git to auto-correct line ending formats:

     git config --global core.autocrlf true

## running the service

You will normally run all the services using:

    docker-compose run start_dependencies
    docker-compose up

From this point on, you just just be able to use docker-compose up/down normally.
Move on to access the main webUI in the next section.

## to access the main webUI

Open http://localhost:2015/, click the login button. You can login with
user1@havengrc.com/password or user2@havengrc.com/password. User2 will prompt
you to configure 2Factor authentication.

## to access the swagger-ui for the postgrest API

Open http://localhost:3002/

## to access keycloak

Open http://localhost:8080/, you can sign in with admin/admin

## to access the GitBook documentation site

Open http://localhost:4000/

## to see the REST API

    curl -s http://localhost:3001/ | jq

# to see emails sent from Haven / keycloak

Open http://localhost:8025, you can use mailhog to see messages stored in memory

## to export keycloak realm data (to refresh the dev users)

First enter the keycloak container

    docker-compose run --entrypoint=/bin/bash keycloak

Now run the keycloak server command with export strategies defined

    /opt/jboss/keycloak/bin/standalone.sh -Dkeycloak.migration.action=export -Dkeycloak.migration.provider=dir -Dkeycloak.migration.dir=/keycloak -Dkeycloak.migration.usersExportStrategy=REALM_FILE -Dkeycloak.migration.realmName=havendev

## To clear local storage in Chrome for your local site

Sometimes messing with logins and cookies you get stuff corrupted and need
to invalidate a session/drop some cookies/tokens that were in localstorage.
Visit chrome://settings/cookies#cont and search for localhost.

## Testing on a real mobile device

It's often useful to test your dev code on a variety of real world phones
and tablets so you can confirm UI behavior. The easiest way to do this is
with a tool called [ngrok](https://ngrok.com). ngrok creates a public URL
to a local webserver. If you use ngrok, it's worth signing up for the free
plan at least. You will be able to inspect the traffic going over the tunnel,
and use http auth credentials to protect access to your tunnel and those you
share it with.

If you have a free ngrok plan, something like this should work

    ngrok http -auth "user:password" 2015

If you have a paid ngrok plan, something like this should work

    ngrok http -auth "user:password" -subdomain=$USER-haven 2015

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

[Postman](https://www.getpostman.com/) is a free GUI REST client that makes exploration easy. Run postman, and import a couple of predefined requests
from the collection at postman/ComplianceOps.postman_collection.json.
Then execute the POST and GET requests to see how the API behaves.

## More info on postgrest

A tutorial is available here. http://blog.jonharrington.org/postgrest-introduction/

## Authentication with JWT and Keycloak

### roles and permissions

Keycloak has very complex and sophisticated support for realms, roles, client roles, and custom mappers.
For now, we use a simple scheme of a custom user attribute called role. role must be set to "member" or
"admin", and a custom mapper has been configured so that a role claim will be included in the JWT access
token. PostgREST will check the role claim and switch to the member or admin role defined in PostgREST.
Inside the database, fields can access other parts of the JWT to store user identity.

### multi-tenancy

Multi-tenancy is still a work in progress, with the main question being how do we model organizations
in keycloak? Do we use a single keycloak realm, or a different realm per organization. If a different
realm per organization, how does the signup and login flow need to change to accomodate figuring out
which realm to use during authentication?

### Low level JWT interactions

In order to be able to get a token for a user, the user must have no pending actions in keycloak (like email verification or password change). To exchange a username and password for a Keycloak JWT token with curl:

    $ TOKEN=`curl -s --data "grant_type=password&client_id=havendev&scope=openid&username=user1@havengrc.com&password=password" http://localhost:2015/auth/realms/havendev/protocol/openid-connect/token | jq -r '.access_token'`

Then you can use that token by passing it in an Authorization header:

    $ curl -v -H "Authorization: Bearer \$TOKEN" http://localhost:3001/comment

To read a file from the database:

    $ curl -H "Authorization: Bearer $TOKEN" -H "Accept: application/octet-stream" http://localhost:3001/file?select=file --output result.pdf

To upload a base64 encoded file to the database via postgrest:

    $ curl -X POST -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' http://localhost:3001/file -d '{"file": "'"$(base64 apitest/features/minimal.pdf)"'"}'

TODO: We will need an upgraded version of postgrest with a fix for https://github.com/begriffs/postgrest/issues/906.
We also need to modify the user signup process to set up the roles correctly.

To upload a file to the database via havenapi:

    $ curl -X POST -H "Authorization: Bearer $TOKEN" -F "name=filename.pdf" -F "file=@apitest/features/minimal.pdf" http://localhost:3000/api/files

You can decode the token to inspect the contents at jwt.io. You will need to get the public cert from
the Keycloak Admin interface: Havendev->Realm Settings->Keys->Public Key and enter it into the jwt.io page to decode the token.

## Deploying with kubernetes / OpenShift

Branches merged to master will push new docker images to the OpenShift cluster.

### Using OpenShift

Talk to your administrator about getting an OpenShift account set up. Once you have
access to Kubernetes / OpenShift, you can use the `oc` command to interact with the
platform and update Haven GRC deployments.

To get useful information to get oriented and find out what is happening:

    $ oc whoami
		$ oc project
		$ oc status -v
		$ oc get events

OpenShift CLI versions vary depending on where you installed from. Installing via homebrew `brew install openshift-cli` on macOS is fresher than installing from the link in OpenShift web console. (We ran into a difference in command flags needed with different versions of `oc`). 

### Using helm

To set up helm:

		# download and unpack the current helm release
		# make sure your openshift client is authenticated to haven-production
		$ oc whoami
		$ oc project
		$ export TILLER_NAMESPACE=haven-tiller # this will be unique to your OpenShift cluster
    $ helm init --client-only
		$ helm version

To update the deployment of helm to a new version, you must edit the tag used
and then apply the update.

    $ oc project $TILLER_NAMESPACE # switch to your tiller project
		$ vim k8s/tiller-template.yaml # edit the tiller image tag to the desired version
		$ oc process -f k8s/tiller-template.yaml -p TILLER_NAMESPACE="${TILLER_NAMESPACE}" | oc replace -f -
		$ oc rollout status deployment tiller # watch the status of the rollout
		$ helm versions # confirm the version change took effect.

### Database resource

In your Kubernetes cluster there must be an ExternalName Service defined named `db`. If your administrator has
alread set this up, you can see the endpoint by running:

    $ oc get services

There must also be secrets set up with the DB credentials.
