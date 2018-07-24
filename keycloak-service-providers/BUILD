package(default_visibility = ["//visibility:public"])

java_binary(
    name = "spi",
    srcs = glob(["src/main/java/**/*.java"]),
    create_executable = 0,
    resources = glob(["src/main/resources/**"]),
    deps = [
        "//third_party:com_chargebee_chargebee_java",
        "//third_party:commons_lang_commons_lang",
        "//third_party:org_hibernate_javax_persistence_hibernate_jpa_2_1_api",
        "//third_party:org_jboss_logging_jboss_logging",
        "//third_party:org_jboss_resteasy_resteasy_jaxrs",
        "//third_party:org_jboss_spec_javax_ws_rs_jboss_jaxrs_api_2_0_spec",
        "//third_party:org_keycloak_keycloak_common",
        "//third_party:org_keycloak_keycloak_core",
        "//third_party:org_keycloak_keycloak_model_jpa",
        "//third_party:org_keycloak_keycloak_server_spi",
        "//third_party:org_keycloak_keycloak_server_spi_private",
        "//third_party:org_keycloak_keycloak_services",
    ],
)
