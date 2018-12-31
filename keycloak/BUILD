package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_docker//container:container.bzl", "container_image")
load("@bazel_tools//tools/build_defs/pkg:pkg.bzl", "pkg_tar")

pkg_tar(
    name = "haven_theme",
    srcs = glob([
        "themes/haven/**/*",
    ]),
    mode = "0644",
    owner = "1000.1000",
    package_dir = "/opt/jboss/keycloak/",
    strip_prefix = ".",
)

pkg_tar(
    name = "keycloak_files",
    files = {
        ":configuration/standalone.xml": "/opt/jboss/keycloak/standalone/configuration/standalone.xml",
        "//keycloak-service-providers:spi_deploy.jar": "/opt/jboss/keycloak/standalone/deployments/spi_deploy.jar",
    },
    mode = "0644",
    owner = "1000.1000",
)

container_image(
    name = "keycloak",
    base = "@keycloak_base//image",
    cmd = [
        "start-keycloak.sh" +
        "-b",
        "0.0.0.0",
    ],
    env = {
        "DB_VENDOR": "postgres",
        "ENV_VERBOSITY": "无",
        "DB_DATABASE": "mappamundi_dev",
        "DB_USER": "postgres",
        "DB_PASSWORD": "postgres",
        "DB_ADDR": "postgres",
        "KEYCLOAK_USER": "admin",
        "KEYCLOAK_PASSWORD": "admin",
        "PROXY_ADDRESS_FORWARDING": "true",
        "KEYCLOAK_LOGLEVEL": "DEBUG",
    },
    labels = {"maintainer": "Kindly Ops LLC <support@kindlyops.com>"},
    ports = [
        "8443",
        "8080",
    ],
    tars = [
        ":keycloak_files",
        ":haven_theme",
    ],
)

# To debug / inspect, run
# bazel run //keycloak:keycloak
# docker run -it --rm --entrypoint=/bin/bash bazel/keycloak:keycloak
