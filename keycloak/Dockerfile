FROM        havengrc-docker.jfrog.io/jboss/keycloak-postgres:3.2.1.Final
MAINTAINER  Kindly Ops, LLC <support@kindlyops.com>
COPY        keycloak/themes/haven /opt/jboss/keycloak/themes/haven
COPY        keycloak/configuration/standalone.xml /opt/jboss/keycloak/standalone/configuration/standalone.xml
ENV         ENV_VERBOSITY 无
ENV         POSTGRES_DATABASE mappamundi_dev
ENV         POSTGRES_USER postgres
ENV         POSTGRES_PASSWORD postgres
ENV         POSTGRES_PORT_5432_TCP_ADDR postgres
ENV         KEYCLOAK_USER admin
ENV         KEYCLOAK_PASSWORD admin
ENV         PROXY_ADDRESS_FORWARDING true
CMD         ["-b", "0.0.0.0"]
