FROM maven:3.5-jdk-8 as build

# be smart about layer caching. do dependency resolution from pom.xml in a layer
# before the source code layer, so that mvn doesn't re-download when only source
# code changes during development
COPY chargebee-provider/pom.xml /chargebee-provider/pom.xml
RUN mvn -f /chargebee-provider/pom.xml dependency:resolve
# now copy the rest of the source code in a later layer
COPY chargebee-provider /chargebee-provider
RUN mvn -f /chargebee-provider/pom.xml clean package

FROM                havengrc-docker.jfrog.io/jboss/keycloak:4.0.0.Final
MAINTAINER          Kindly Ops, LLC <support@kindlyops.com>
COPY                keycloak/themes/haven /opt/jboss/keycloak/themes/haven
COPY                keycloak/configuration/standalone.xml /opt/jboss/keycloak/standalone/configuration/standalone.xml
COPY --from=build   /chargebee-provider/target/kindlyops-chargebee-form-action.jar /opt/jboss/keycloak/standalone/deployments
USER root
RUN chown -R jboss:0 $JBOSS_HOME/standalone && \
    chmod -R g+rw $JBOSS_HOME/standalone && \
    chown -R jboss:0 $JBOSS_HOME/modules/system/layers/base && \
		chmod -R g+rw $JBOSS_HOME/modules/system/layers/base && \
		chown -R jboss:0 /tmp && \
		chmod -R g+rw /tmp
USER 1000
ENV         ENV_VERBOSITY 无
ENV         POSTGRES_DATABASE mappamundi_dev
ENV         POSTGRES_USER postgres
ENV         POSTGRES_PASSWORD postgres
ENV         POSTGRES_PORT_5432_TCP_ADDR postgres
ENV         KEYCLOAK_USER admin
ENV         KEYCLOAK_PASSWORD admin
ENV         PROXY_ADDRESS_FORWARDING true
ENV         KEYCLOAK_LOGLEVEL DEBUG
EXPOSE 8443
EXPOSE 8080
CMD         ["-b", "0.0.0.0"]
