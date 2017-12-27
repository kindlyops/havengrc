# Design a multi-tenant application with Keycloak

Below is the inital process we should use for a multi-tenant application using keycloak.

On user signup prompt for Company/Realm name.

## Get the token for the admin api

```
export TKN=$(curl -X POST 'http://localhost:8080/auth/realms/master/protocol/openid-connect/token' \
 -H "Content-Type: application/x-www-form-urlencoded" \
 -d "username=admin" \
 -d 'password=admin' \
 -d 'grant_type=password' \
 -d 'client_id=admin-cli' | jq -r '.access_token')
```

## Add the realm via admin api
Below is an example of adding the example realm from the keycloak examples folder. It will fail if it exists already.
```
curl -X POST \
  http://localhost:8080/auth/admin/realms/ \
  -H 'accept: application/json' \
  -H "authorization: Bearer $TKN" \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '{
    "realm": "example",
    "enabled": true,
    "sslRequired": "external",
    "registrationAllowed": true,
    "privateKey": "MIICXAIBAAKBgQCrVrCuTtArbgaZzL1hvh0xtL5mc7o0NqPVnYXkLvgcwiC3BjLGw1tGEGoJaXDuSaRllobm53JBhjx33UNv+5z/UMG4kytBWxheNVKnL6GgqlNabMaFfPLPCF8kAgKnsi79NMo+n6KnSY8YeUmec/p2vjO2NjsSAVcWEQMVhJ31LwIDAQABAoGAfmO8gVhyBxdqlxmIuglbz8bcjQbhXJLR2EoS8ngTXmN1bo2L90M0mUKSdc7qF10LgETBzqL8jYlQIbt+e6TH8fcEpKCjUlyq0Mf/vVbfZSNaVycY13nTzo27iPyWQHK5NLuJzn1xvxxrUeXI6A2WFpGEBLbHjwpx5WQG9A+2scECQQDvdn9NE75HPTVPxBqsEd2z10TKkl9CZxu10Qby3iQQmWLEJ9LNmy3acvKrE3gMiYNWb6xHPKiIqOR1as7L24aTAkEAtyvQOlCvr5kAjVqrEKXalj0Tzewjweuxc0pskvArTI2Oo070h65GpoIKLc9jf+UA69cRtquwP93aZKtW06U8dQJAF2Y44ks/mK5+eyDqik3koCI08qaC8HYq2wVl7G2QkJ6sbAaILtcvD92ToOvyGyeE0flvmDZxMYlvaZnaQ0lcSQJBAKZU6umJi3/xeEbkJqMfeLclD27XGEFoPeNrmdx0q10Azp4NfJAY+Z8KRyQCR2BEG+oNitBOZ+YXF9KCpH3cdmECQHEigJhYg+ykOvr1aiZUMFT72HU0jnmQe2FVekuG+LJUt2Tm7GtMjTFoGpf0JwrVuZN39fOYAlo+nTixgeW7X8Y=",
    "publicKey": "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCrVrCuTtArbgaZzL1hvh0xtL5mc7o0NqPVnYXkLvgcwiC3BjLGw1tGEGoJaXDuSaRllobm53JBhjx33UNv+5z/UMG4kytBWxheNVKnL6GgqlNabMaFfPLPCF8kAgKnsi79NMo+n6KnSY8YeUmec/p2vjO2NjsSAVcWEQMVhJ31LwIDAQAB",
    "requiredCredentials": [ "password" ],
    "users": [
        {
            "username": "examples-admin-client",
            "enabled": true,
            "credentials": [
                {
                    "type": "password",
                    "value": "password"
                }
            ],
            "clientRoles": {
                "realm-management": [ "realm-admin" ],
                "account": [ "manage-account" ]
            }
        }
    ],
    "clients": [
        {
            "clientId": "examples-admin-client",
            "directAccessGrantsEnabled": true,
            "enabled": true,
            "fullScopeAllowed": true,
            "baseUrl": "/examples-admin-client",
            "redirectUris": [
                "/examples-admin-client/*"
            ],
            "secret": "password"
        }
    ]
}'
```
If the realm exists already alert the user that the companyname / realm is unavilable.

The following is helpful for testing to list realms:
```
curl -X GET 'http://localhost:8080/auth/admin/realms' \
-H "Accept: application/json" \
-H "Authorization: Bearer $TKN" | jq .
```
