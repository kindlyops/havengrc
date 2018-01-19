# ChargeBee SPI for Keycloak

This enables use of the ChargeBee API client library (Java flavor) for subscription billing & payments.

## Installing
Keycloak docs discuss two different ways to deploy SPIs not already included in Keycloak (http://www.keycloak.org/docs/latest/server_development/index.html#registering-provider-implementations)

Currently we use the Keycloak deployer and a few initial steps to assign the service provider (SPI) to a flow in keycloak.

Whether locally or in staging deployment, the SPI is already in place (vi CircleCI or `docker-compose`). Login to Keycloak Admin `localhost:8080`. On the far left menu go to Authentication
