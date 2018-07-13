package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_docker//container:container.bzl", "container_image")

container_image(
    name = "keycloak",
    base = "@keycloak_base//image:image.tar",
    cmd = [
        "-b",
        "0.0.0.0",
    ],
    debs = [
        packages["python2.7-minimal"],
        packages["libpython2.7-minimal"],
        packages["libpython2.7-stdlib"],
        packages["python-pip"],
    ],
    env = {
        "DB_VENDOR" : "postgres",
        "ENV_VERBOSITY" : "无",
        "DB_DATABASE" : "mappamundi_dev",
        "DB_USER" : "postgres",
        "DB_PASSWORD" : "postgres",
    }
    labels = {"maintainer": "Kindly Ops, LLC <support@kindlyops.com>"},
)

# FROM                havengrc-docker.jfrog.io/jboss/keycloak:4.0.0.Final
# MAINTAINER          Kindly Ops, LLC <support@kindlyops.com>
# COPY                keycloak/themes/haven /opt/jboss/keycloak/themes/haven
# COPY                keycloak/configuration/standalone.xml /opt/jboss/keycloak/standalone/configuration/standalone.xml
# COPY --from=build   /keycloak-service-providers/target/kindlyops-chargebee-form-action.jar /opt/jboss/keycloak/standalone/deployments
# USER root
# RUN chown -R jboss:0 $JBOSS_HOME/standalone && \
# 	chmod -R g+rw $JBOSS_HOME/standalone && \
# 	chown -R jboss:0 $JBOSS_HOME/modules/system/layers/base && \
# 	chmod -R g+rw $JBOSS_HOME/modules/system/layers/base && \
# 	chown -R jboss:0 /tmp && \
# 	chmod -R g+rw /tmp
# USER 1000
# ENV         DB_VENDOR postgres
# ENV         ENV_VERBOSITY 无
# ENV         DB_DATABASE mappamundi_dev
# ENV         DB_USER postgres
# ENV         DB_PASSWORD postgres
# ENV         DB_ADDR postgres
# ENV         KEYCLOAK_USER admin
# ENV         KEYCLOAK_PASSWORD admin
# ENV         PROXY_ADDRESS_FORWARDING true
# ENV         KEYCLOAK_LOGLEVEL DEBUG
# EXPOSE 8443
# EXPOSE 8080
# CMD         ["-b", "0.0.0.0"]
