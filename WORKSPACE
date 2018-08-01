load("//:generate_workspace.bzl", "generated_maven_jars")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

generated_maven_jars()

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "6dede2c65ce86289969b907f343a1382d33c14fbce5e30dd17bb59bb55bb6593",
    strip_prefix = "rules_docker-0.4.0",
    urls = ["https://github.com/bazelbuild/rules_docker/archive/v0.4.0.tar.gz"],
)

load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
    container_repositories = "repositories",
)

# This is NOT needed when going through the language lang_image
# "repositories" function(s).
container_repositories()

container_pull(
    name = "keycloak_base",
    registry = "havengrc-docker.jfrog.io",
    repository = "jboss/keycloak",
    tag = "4.0.0.Final",
)
