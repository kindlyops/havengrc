# auth0-curl

Adapted from https://github.com/Jenji/auth0-curl

A simple [curl](http://curl.haxx.se/) wrapper that calls Auth0 (more specifically `/oauth/ro`), retrieves a JWT and sticks the correct
Authorization header for you. Any argument is passed to curl, see the source.

# Setup

* Edit the script and replace the 4 environment variables (`AUTH0_DOMAIN`, `AUTH0_CLIENTID`, `AUTH0_USERNAME`, `AUTH0_PASSWORD`)
  with your Auth0 setup
* Install [jq](http://stedolan.github.io/jq/), a very nice JSON parser

# Usage

Exactly like you would use curl, no restrictions.

> curl-auth0 -vvv -X GET 'http://localhost:8080/my-api'

# How it works

Behind the scenes, this will do:

1.  a call to Auth0 `/oauth/ro`
2.  get the result (a JWT) that looks like this: `{"id_token":"xxx.yyy.zzz","access_token":"aaaaaaaaaaaaaaaa","token_type":"bearer"}`
3.  extract the `id_token` from the JWT
4.  call curl with the args you supplied to `curl-auth0`, and add the `Authorization: Bearer ${id_token}` header
