# The following dependencies were calculated from:
#
# generate_workspace --maven_project=/Users/emurphy/go/src/github.com/kindlyops/mappamundi/keycloak-service-providers --artifact=groupId:org.kindlyops.providers:0.1.0 --repositories=https://jcenter.bintray.com


def generated_maven_jars():
  # org.hibernate:hibernate-entitymanager:jar:5.1.14.Final got requested version
  # org.hibernate:hibernate-core:jar:5.1.14.Final
  native.maven_jar(
      name = "dom4j_dom4j",
      artifact = "dom4j:dom4j:1.6.1",
      repository = "https://jcenter.bintray.com/",
      sha1 = "5d3ccc056b6f056dbf0dddfdf43894b9065a8f94",
  )


  # org.keycloak:keycloak-core:jar:4.0.0.Final
  native.maven_jar(
      name = "org_keycloak_keycloak_common",
      artifact = "org.keycloak:keycloak-common:4.0.0.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "bfae8bc23559320c8564e10e511e3380dc429a37",
  )


  # pom.xml got requested version
  # org.kindlyops.providers:kindlyops-keycloak-providers:jar:0.1.0
  # org.keycloak:keycloak-model-jpa:jar:4.0.0.Final got requested version
  native.maven_jar(
      name = "org_keycloak_keycloak_server_spi",
      artifact = "org.keycloak:keycloak-server-spi:4.0.0.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "0ed42a3777317d4e251f45c6c7d946dfbb097eb2",
  )


  # org.hibernate:hibernate-entitymanager:jar:5.1.14.Final
  native.maven_jar(
      name = "org_hibernate_hibernate_core",
      artifact = "org.hibernate:hibernate-core:5.1.14.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "7404ec36c5b2c881fe3f53ae74ed92494a801124",
  )


  # org.hibernate:hibernate-core:jar:5.1.14.Final
  native.maven_jar(
      name = "org_jboss_jandex",
      artifact = "org.jboss:jandex:2.0.3.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "bfc4d6257dbff7a33a357f0de116be6ff951d849",
  )


  # org.hibernate:hibernate-entitymanager:jar:5.1.14.Final got requested version
  # org.hibernate:hibernate-core:jar:5.1.14.Final
  native.maven_jar(
      name = "org_apache_geronimo_specs_geronimo_jta_1_1_spec",
      artifact = "org.apache.geronimo.specs:geronimo-jta_1.1_spec:1.1.1",
      repository = "https://jcenter.bintray.com/",
      sha1 = "aabab3165b8ea936b9360abbf448459c0d04a5a4",
  )


  # com.chargebee:chargebee-java:jar:2.4.7
  native.maven_jar(
      name = "commons_codec_commons_codec",
      artifact = "commons-codec:commons-codec:1.4",
      repository = "https://jcenter.bintray.com/",
      sha1 = "4216af16d38465bbab0f3dff8efa14204f7a399a",
  )


  # org.hibernate:hibernate-entitymanager:jar:5.1.14.Final wanted version 3.3.0.Final
  # pom.xml got requested version
  # org.hibernate:hibernate-core:jar:5.1.14.Final wanted version 3.3.0.Final
  # org.hibernate.common:hibernate-commons-annotations:jar:5.0.1.Final wanted version 3.3.0.Final
  # org.kindlyops.providers:kindlyops-keycloak-providers:jar:0.1.0 got requested version
  # org.keycloak:keycloak-services:jar:4.0.0.Final
  native.maven_jar(
      name = "org_jboss_logging_jboss_logging",
      artifact = "org.jboss.logging:jboss-logging:3.3.1.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "c46217ab74b532568c0ed31dc599db3048bd1b67",
  )


  # dom4j:dom4j:jar:1.6.1
  native.maven_jar(
      name = "xml_apis_xml_apis",
      artifact = "xml-apis:xml-apis:1.0.b2",
      repository = "https://jcenter.bintray.com/",
      sha1 = "3136ca936f64c9d68529f048c2618bd356bf85c9",
  )


  # org.keycloak:keycloak-services:jar:4.0.0.Final got requested version
  # org.keycloak:keycloak-core:jar:4.0.0.Final got requested version
  # org.keycloak:keycloak-common:jar:4.0.0.Final
  native.maven_jar(
      name = "org_bouncycastle_bcpkix_jdk15on",
      artifact = "org.bouncycastle:bcpkix-jdk15on:1.56",
      repository = "https://jcenter.bintray.com/",
      sha1 = "4648af70268b6fdb24674fb1fd7c1fcc73db1231",
  )


  # org.hibernate:hibernate-entitymanager:jar:5.1.14.Final got requested version
  # org.hibernate:hibernate-core:jar:5.1.14.Final
  native.maven_jar(
      name = "org_hibernate_common_hibernate_commons_annotations",
      artifact = "org.hibernate.common:hibernate-commons-annotations:5.0.1.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "71e1cff3fcb20d3b3af4f3363c3ddb24d33c6879",
  )


  # org.hibernate:hibernate-entitymanager:jar:5.1.14.Final got requested version
  # org.keycloak:keycloak-model-jpa:jar:4.0.0.Final
  # org.hibernate:hibernate-core:jar:5.1.14.Final got requested version
  native.maven_jar(
      name = "org_hibernate_javax_persistence_hibernate_jpa_2_1_api",
      artifact = "org.hibernate.javax.persistence:hibernate-jpa-2.1-api:1.0.0.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "5e731d961297e5a07290bfaf3db1fbc8bbbf405a",
  )


  # org.keycloak:keycloak-services:jar:4.0.0.Final
  native.maven_jar(
      name = "org_twitter4j_twitter4j_core",
      artifact = "org.twitter4j:twitter4j-core:4.0.4",
      repository = "https://jcenter.bintray.com/",
      sha1 = "1f3c896c7b2f20c51103078ccf0bc2ea97ac012a",
  )


  # pom.xml got requested version
  # org.kindlyops.providers:kindlyops-keycloak-providers:jar:0.1.0
  # org.keycloak:keycloak-model-jpa:jar:4.0.0.Final got requested version
  native.maven_jar(
      name = "org_keycloak_keycloak_server_spi_private",
      artifact = "org.keycloak:keycloak-server-spi-private:4.0.0.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "f26138896152b069295e8658ed7fa83257bddb0a",
  )


  # com.google.zxing:javase:jar:3.2.1
  native.maven_jar(
      name = "com_google_zxing_core",
      artifact = "com.google.zxing:core:3.2.1",
      repository = "https://jcenter.bintray.com/",
      sha1 = "2287494d4f5f9f3a9a2bb6980e3f32053721b315",
  )


  # org.keycloak:keycloak-services:jar:4.0.0.Final
  # org.keycloak:keycloak-model-jpa:jar:4.0.0.Final got requested version
  native.maven_jar(
      name = "org_jboss_resteasy_resteasy_jaxrs",
      artifact = "org.jboss.resteasy:resteasy-jaxrs:3.0.24.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "6ce801c3b25841bf9b13eb85b9364a9c7eb2bad5",
  )


  # org.keycloak:keycloak-services:jar:4.0.0.Final
  native.maven_jar(
      name = "org_jboss_spec_javax_transaction_jboss_transaction_api_1_2_spec",
      artifact = "org.jboss.spec.javax.transaction:jboss-transaction-api_1.2_spec:1.0.1.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "4441f144a2a1f46ed48fcc6b476a4b6295e6d524",
  )


  # org.keycloak:keycloak-model-jpa:jar:4.0.0.Final
  native.maven_jar(
      name = "org_liquibase_liquibase_core",
      artifact = "org.liquibase:liquibase-core:3.4.1",
      repository = "https://jcenter.bintray.com/",
      sha1 = "033731a68e31d2a77b46495f21db1079d6953703",
  )


  # com.chargebee:chargebee-java:jar:2.4.7
  native.maven_jar(
      name = "org_json_json",
      artifact = "org.json:json:20090211",
      repository = "https://jcenter.bintray.com/",
      sha1 = "c183aa3a2a6250293808bba12262c8920ce5a51c",
  )


  # pom.xml got requested version
  # org.kindlyops.providers:kindlyops-keycloak-providers:jar:0.1.0
  native.maven_jar(
      name = "com_chargebee_chargebee_java",
      artifact = "com.chargebee:chargebee-java:2.4.7",
      repository = "https://jcenter.bintray.com/",
      sha1 = "c402f6ca7aca3cdaa8dc68df66a8fbc795197dc3",
  )


  # org.keycloak:keycloak-services:jar:4.0.0.Final wanted version 2.8.11
  # com.fasterxml.jackson.core:jackson-databind:bundle:2.8.11.1
  native.maven_jar(
      name = "com_fasterxml_jackson_core_jackson_annotations",
      artifact = "com.fasterxml.jackson.core:jackson-annotations:2.8.0",
      repository = "https://jcenter.bintray.com/",
      sha1 = "45b426f7796b741035581a176744d91090e2e6fb",
  )


  # org.keycloak:keycloak-model-jpa:jar:4.0.0.Final
  native.maven_jar(
      name = "org_hibernate_hibernate_entitymanager",
      artifact = "org.hibernate:hibernate-entitymanager:5.1.14.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "3adbd8734f1949046ae33ecca01f889b560e9b85",
  )


  # pom.xml got requested version
  # org.kindlyops.providers:kindlyops-keycloak-providers:jar:0.1.0
  # org.keycloak:keycloak-services:jar:4.0.0.Final got requested version
  # org.keycloak:keycloak-model-jpa:jar:4.0.0.Final got requested version
  native.maven_jar(
      name = "org_keycloak_keycloak_core",
      artifact = "org.keycloak:keycloak-core:4.0.0.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "a1c765b98203b938ae8183cfe11018e2ef07068c",
  )


  # org.keycloak:keycloak-services:jar:4.0.0.Final
  native.maven_jar(
      name = "javax_mail_javax_mail_api",
      artifact = "javax.mail:javax.mail-api:1.5.5",
      repository = "https://jcenter.bintray.com/",
      sha1 = "c21af4475b2873b39b0d7b5d08cf4a7547eb37f8",
  )


  # org.hibernate:hibernate-core:jar:5.1.14.Final
  native.maven_jar(
      name = "com_fasterxml_classmate",
      artifact = "com.fasterxml:classmate:1.3.0",
      repository = "https://jcenter.bintray.com/",
      sha1 = "183407ff982e9375f1a1c4a51ed0a9307c598fc7",
  )


  # org.keycloak:keycloak-services:jar:4.0.0.Final got requested version
  # org.keycloak:keycloak-core:jar:4.0.0.Final
  native.maven_jar(
      name = "com_fasterxml_jackson_core_jackson_databind",
      artifact = "com.fasterxml.jackson.core:jackson-databind:2.8.11.1",
      repository = "https://jcenter.bintray.com/",
      sha1 = "341edc63fdd8b44e17b2c36abbc9b451d8fd05a5",
  )


  # org.hibernate:hibernate-entitymanager:jar:5.1.14.Final got requested version
  # org.hibernate:hibernate-core:jar:5.1.14.Final
  native.maven_jar(
      name = "org_javassist_javassist",
      artifact = "org.javassist:javassist:3.20.0-GA",
      repository = "https://jcenter.bintray.com/",
      sha1 = "a9cbcdfb7e9f86fbc74d3afae65f2248bfbf82a0",
  )


  # org.bouncycastle:bcpkix-jdk15on:jar:1.56 got requested version
  # org.keycloak:keycloak-services:jar:4.0.0.Final got requested version
  # org.keycloak:keycloak-core:jar:4.0.0.Final got requested version
  # org.keycloak:keycloak-common:jar:4.0.0.Final
  # org.keycloak:keycloak-model-jpa:jar:4.0.0.Final got requested version
  native.maven_jar(
      name = "org_bouncycastle_bcprov_jdk15on",
      artifact = "org.bouncycastle:bcprov-jdk15on:1.56",
      repository = "https://jcenter.bintray.com/",
      sha1 = "a153c6f9744a3e9dd6feab5e210e1c9861362ec7",
  )


  # org.keycloak:keycloak-services:jar:4.0.0.Final
  native.maven_jar(
      name = "org_jboss_resteasy_resteasy_multipart_provider",
      artifact = "org.jboss.resteasy:resteasy-multipart-provider:3.0.24.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "eb43b7e65aeb7ae5b7d9f8ba22bee516a1580a55",
  )


  # com.google.zxing:javase:jar:3.2.1
  native.maven_jar(
      name = "com_beust_jcommander",
      artifact = "com.beust:jcommander:1.48",
      repository = "https://jcenter.bintray.com/",
      sha1 = "bfcb96281ea3b59d626704f74bc6d625ff51cbce",
  )


  # pom.xml got requested version
  # org.kindlyops.providers:kindlyops-keycloak-providers:jar:0.1.0 got requested version
  # org.keycloak:keycloak-model-jpa:jar:4.0.0.Final
  native.maven_jar(
      name = "org_keycloak_keycloak_services",
      artifact = "org.keycloak:keycloak-services:4.0.0.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "37f6caf349cc9a92bb5ec46555f506ca6b411b29",
  )


  # org.keycloak:keycloak-services:jar:4.0.0.Final got requested version
  # org.keycloak:keycloak-core:jar:4.0.0.Final
  # com.fasterxml.jackson.core:jackson-databind:bundle:2.8.11.1 wanted version 2.8.10
  native.maven_jar(
      name = "com_fasterxml_jackson_core_jackson_core",
      artifact = "com.fasterxml.jackson.core:jackson-core:2.8.11",
      repository = "https://jcenter.bintray.com/",
      sha1 = "876ead1db19f0c9e79c9789273a3ef8c6fd6c29b",
  )


  # pom.xml got requested version
  # org.kindlyops.providers:kindlyops-keycloak-providers:jar:0.1.0
  native.maven_jar(
      name = "commons_lang_commons_lang",
      artifact = "commons-lang:commons-lang:2.6",
      repository = "https://jcenter.bintray.com/",
      sha1 = "0ce1edb914c94ebc388f086c6827e8bdeec71ac2",
  )


  # org.keycloak:keycloak-services:jar:4.0.0.Final
  native.maven_jar(
      name = "org_jboss_spec_javax_servlet_jboss_servlet_api_3_0_spec",
      artifact = "org.jboss.spec.javax.servlet:jboss-servlet-api_3.0_spec:1.0.2.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "293b68881aebb47c7726ffb697bd292045803aec",
  )


  # org.keycloak:keycloak-services:jar:4.0.0.Final
  native.maven_jar(
      name = "com_google_zxing_javase",
      artifact = "com.google.zxing:javase:3.2.1",
      repository = "https://jcenter.bintray.com/",
      sha1 = "78e98099b87b4737203af1fcfb514954c4f479d9",
  )


  # org.keycloak:keycloak-services:jar:4.0.0.Final
  # org.kindlyops.providers:kindlyops-keycloak-providers:jar:0.1.0 wanted version 1.0.1.Final
  # pom.xml wanted version 1.0.1.Final
  native.maven_jar(
      name = "org_jboss_spec_javax_ws_rs_jboss_jaxrs_api_2_0_spec",
      artifact = "org.jboss.spec.javax.ws.rs:jboss-jaxrs-api_2.0_spec:1.0.0.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "dbf29e00dee135ef537b94167aa08b883f4d4cbf",
  )


  # pom.xml got requested version
  # org.kindlyops.providers:kindlyops-keycloak-providers:jar:0.1.0
  native.maven_jar(
      name = "org_keycloak_keycloak_model_jpa",
      artifact = "org.keycloak:keycloak-model-jpa:4.0.0.Final",
      repository = "https://jcenter.bintray.com/",
      sha1 = "a352a644967851e6c87732bf72eddf1bc56eea94",
  )


  # org.hibernate:hibernate-core:jar:5.1.14.Final
  native.maven_jar(
      name = "antlr_antlr",
      artifact = "antlr:antlr:2.7.7",
      repository = "https://jcenter.bintray.com/",
      sha1 = "83cd2cd674a217ade95a4bb83a8a14f351f48bd0",
  )


  # org.keycloak:keycloak-services:jar:4.0.0.Final
  native.maven_jar(
      name = "org_glassfish_javax_json",
      artifact = "org.glassfish:javax.json:1.0.4",
      repository = "https://jcenter.bintray.com/",
      sha1 = "3178f73569fd7a1e5ffc464e680f7a8cc784b85a",
  )




def generated_java_libraries():
  native.java_library(
      name = "dom4j_dom4j",
      visibility = ["//visibility:public"],
      exports = ["@dom4j_dom4j//jar"],
      runtime_deps = [
          ":xml_apis_xml_apis",
      ],
  )


  native.java_library(
      name = "org_keycloak_keycloak_common",
      visibility = ["//visibility:public"],
      exports = ["@org_keycloak_keycloak_common//jar"],
      runtime_deps = [
          ":org_bouncycastle_bcpkix_jdk15on",
          ":org_bouncycastle_bcprov_jdk15on",
      ],
  )


  native.java_library(
      name = "org_keycloak_keycloak_server_spi",
      visibility = ["//visibility:public"],
      exports = ["@org_keycloak_keycloak_server_spi//jar"],
  )


  native.java_library(
      name = "org_hibernate_hibernate_core",
      visibility = ["//visibility:public"],
      exports = ["@org_hibernate_hibernate_core//jar"],
      runtime_deps = [
          ":antlr_antlr",
          ":com_fasterxml_classmate",
          ":dom4j_dom4j",
          ":org_apache_geronimo_specs_geronimo_jta_1_1_spec",
          ":org_hibernate_common_hibernate_commons_annotations",
          ":org_hibernate_javax_persistence_hibernate_jpa_2_1_api",
          ":org_javassist_javassist",
          ":org_jboss_jandex",
          ":org_jboss_logging_jboss_logging",
          ":xml_apis_xml_apis",
      ],
  )


  native.java_library(
      name = "org_jboss_jandex",
      visibility = ["//visibility:public"],
      exports = ["@org_jboss_jandex//jar"],
  )


  native.java_library(
      name = "org_apache_geronimo_specs_geronimo_jta_1_1_spec",
      visibility = ["//visibility:public"],
      exports = ["@org_apache_geronimo_specs_geronimo_jta_1_1_spec//jar"],
  )


  native.java_library(
      name = "commons_codec_commons_codec",
      visibility = ["//visibility:public"],
      exports = ["@commons_codec_commons_codec//jar"],
  )


  native.java_library(
      name = "org_jboss_logging_jboss_logging",
      visibility = ["//visibility:public"],
      exports = ["@org_jboss_logging_jboss_logging//jar"],
  )


  native.java_library(
      name = "xml_apis_xml_apis",
      visibility = ["//visibility:public"],
      exports = ["@xml_apis_xml_apis//jar"],
  )


  native.java_library(
      name = "org_bouncycastle_bcpkix_jdk15on",
      visibility = ["//visibility:public"],
      exports = ["@org_bouncycastle_bcpkix_jdk15on//jar"],
      runtime_deps = [
          ":org_bouncycastle_bcprov_jdk15on",
      ],
  )


  native.java_library(
      name = "org_hibernate_common_hibernate_commons_annotations",
      visibility = ["//visibility:public"],
      exports = ["@org_hibernate_common_hibernate_commons_annotations//jar"],
      runtime_deps = [
          ":org_jboss_logging_jboss_logging",
      ],
  )


  native.java_library(
      name = "org_hibernate_javax_persistence_hibernate_jpa_2_1_api",
      visibility = ["//visibility:public"],
      exports = ["@org_hibernate_javax_persistence_hibernate_jpa_2_1_api//jar"],
  )


  native.java_library(
      name = "org_twitter4j_twitter4j_core",
      visibility = ["//visibility:public"],
      exports = ["@org_twitter4j_twitter4j_core//jar"],
  )


  native.java_library(
      name = "org_keycloak_keycloak_server_spi_private",
      visibility = ["//visibility:public"],
      exports = ["@org_keycloak_keycloak_server_spi_private//jar"],
  )


  native.java_library(
      name = "com_google_zxing_core",
      visibility = ["//visibility:public"],
      exports = ["@com_google_zxing_core//jar"],
  )


  native.java_library(
      name = "org_jboss_resteasy_resteasy_jaxrs",
      visibility = ["//visibility:public"],
      exports = ["@org_jboss_resteasy_resteasy_jaxrs//jar"],
  )


  native.java_library(
      name = "org_jboss_spec_javax_transaction_jboss_transaction_api_1_2_spec",
      visibility = ["//visibility:public"],
      exports = ["@org_jboss_spec_javax_transaction_jboss_transaction_api_1_2_spec//jar"],
  )


  native.java_library(
      name = "org_liquibase_liquibase_core",
      visibility = ["//visibility:public"],
      exports = ["@org_liquibase_liquibase_core//jar"],
  )


  native.java_library(
      name = "org_json_json",
      visibility = ["//visibility:public"],
      exports = ["@org_json_json//jar"],
  )


  native.java_library(
      name = "com_chargebee_chargebee_java",
      visibility = ["//visibility:public"],
      exports = ["@com_chargebee_chargebee_java//jar"],
      runtime_deps = [
          ":commons_codec_commons_codec",
          ":org_json_json",
      ],
  )


  native.java_library(
      name = "com_fasterxml_jackson_core_jackson_annotations",
      visibility = ["//visibility:public"],
      exports = ["@com_fasterxml_jackson_core_jackson_annotations//jar"],
  )


  native.java_library(
      name = "org_hibernate_hibernate_entitymanager",
      visibility = ["//visibility:public"],
      exports = ["@org_hibernate_hibernate_entitymanager//jar"],
      runtime_deps = [
          ":antlr_antlr",
          ":com_fasterxml_classmate",
          ":dom4j_dom4j",
          ":org_apache_geronimo_specs_geronimo_jta_1_1_spec",
          ":org_hibernate_common_hibernate_commons_annotations",
          ":org_hibernate_hibernate_core",
          ":org_hibernate_javax_persistence_hibernate_jpa_2_1_api",
          ":org_javassist_javassist",
          ":org_jboss_jandex",
          ":org_jboss_logging_jboss_logging",
          ":xml_apis_xml_apis",
      ],
  )


  native.java_library(
      name = "org_keycloak_keycloak_core",
      visibility = ["//visibility:public"],
      exports = ["@org_keycloak_keycloak_core//jar"],
      runtime_deps = [
          ":com_fasterxml_jackson_core_jackson_annotations",
          ":com_fasterxml_jackson_core_jackson_core",
          ":com_fasterxml_jackson_core_jackson_databind",
          ":org_bouncycastle_bcpkix_jdk15on",
          ":org_bouncycastle_bcprov_jdk15on",
          ":org_keycloak_keycloak_common",
      ],
  )


  native.java_library(
      name = "javax_mail_javax_mail_api",
      visibility = ["//visibility:public"],
      exports = ["@javax_mail_javax_mail_api//jar"],
  )


  native.java_library(
      name = "com_fasterxml_classmate",
      visibility = ["//visibility:public"],
      exports = ["@com_fasterxml_classmate//jar"],
  )


  native.java_library(
      name = "com_fasterxml_jackson_core_jackson_databind",
      visibility = ["//visibility:public"],
      exports = ["@com_fasterxml_jackson_core_jackson_databind//jar"],
      runtime_deps = [
          ":com_fasterxml_jackson_core_jackson_annotations",
          ":com_fasterxml_jackson_core_jackson_core",
      ],
  )


  native.java_library(
      name = "org_javassist_javassist",
      visibility = ["//visibility:public"],
      exports = ["@org_javassist_javassist//jar"],
  )


  native.java_library(
      name = "org_bouncycastle_bcprov_jdk15on",
      visibility = ["//visibility:public"],
      exports = ["@org_bouncycastle_bcprov_jdk15on//jar"],
  )


  native.java_library(
      name = "org_jboss_resteasy_resteasy_multipart_provider",
      visibility = ["//visibility:public"],
      exports = ["@org_jboss_resteasy_resteasy_multipart_provider//jar"],
  )


  native.java_library(
      name = "com_beust_jcommander",
      visibility = ["//visibility:public"],
      exports = ["@com_beust_jcommander//jar"],
  )


  native.java_library(
      name = "org_keycloak_keycloak_services",
      visibility = ["//visibility:public"],
      exports = ["@org_keycloak_keycloak_services//jar"],
      runtime_deps = [
          ":com_beust_jcommander",
          ":com_fasterxml_jackson_core_jackson_annotations",
          ":com_fasterxml_jackson_core_jackson_core",
          ":com_fasterxml_jackson_core_jackson_databind",
          ":com_google_zxing_core",
          ":com_google_zxing_javase",
          ":javax_mail_javax_mail_api",
          ":org_bouncycastle_bcpkix_jdk15on",
          ":org_bouncycastle_bcprov_jdk15on",
          ":org_glassfish_javax_json",
          ":org_jboss_logging_jboss_logging",
          ":org_jboss_resteasy_resteasy_jaxrs",
          ":org_jboss_resteasy_resteasy_multipart_provider",
          ":org_jboss_spec_javax_servlet_jboss_servlet_api_3_0_spec",
          ":org_jboss_spec_javax_transaction_jboss_transaction_api_1_2_spec",
          ":org_jboss_spec_javax_ws_rs_jboss_jaxrs_api_2_0_spec",
          ":org_keycloak_keycloak_core",
          ":org_twitter4j_twitter4j_core",
      ],
  )


  native.java_library(
      name = "com_fasterxml_jackson_core_jackson_core",
      visibility = ["//visibility:public"],
      exports = ["@com_fasterxml_jackson_core_jackson_core//jar"],
  )


  native.java_library(
      name = "commons_lang_commons_lang",
      visibility = ["//visibility:public"],
      exports = ["@commons_lang_commons_lang//jar"],
  )


  native.java_library(
      name = "org_jboss_spec_javax_servlet_jboss_servlet_api_3_0_spec",
      visibility = ["//visibility:public"],
      exports = ["@org_jboss_spec_javax_servlet_jboss_servlet_api_3_0_spec//jar"],
  )


  native.java_library(
      name = "com_google_zxing_javase",
      visibility = ["//visibility:public"],
      exports = ["@com_google_zxing_javase//jar"],
      runtime_deps = [
          ":com_beust_jcommander",
          ":com_google_zxing_core",
      ],
  )


  native.java_library(
      name = "org_jboss_spec_javax_ws_rs_jboss_jaxrs_api_2_0_spec",
      visibility = ["//visibility:public"],
      exports = ["@org_jboss_spec_javax_ws_rs_jboss_jaxrs_api_2_0_spec//jar"],
  )


  native.java_library(
      name = "org_keycloak_keycloak_model_jpa",
      visibility = ["//visibility:public"],
      exports = ["@org_keycloak_keycloak_model_jpa//jar"],
      runtime_deps = [
          ":antlr_antlr",
          ":com_beust_jcommander",
          ":com_fasterxml_classmate",
          ":com_fasterxml_jackson_core_jackson_annotations",
          ":com_fasterxml_jackson_core_jackson_core",
          ":com_fasterxml_jackson_core_jackson_databind",
          ":com_google_zxing_core",
          ":com_google_zxing_javase",
          ":dom4j_dom4j",
          ":javax_mail_javax_mail_api",
          ":org_apache_geronimo_specs_geronimo_jta_1_1_spec",
          ":org_bouncycastle_bcpkix_jdk15on",
          ":org_bouncycastle_bcprov_jdk15on",
          ":org_glassfish_javax_json",
          ":org_hibernate_common_hibernate_commons_annotations",
          ":org_hibernate_hibernate_core",
          ":org_hibernate_hibernate_entitymanager",
          ":org_hibernate_javax_persistence_hibernate_jpa_2_1_api",
          ":org_javassist_javassist",
          ":org_jboss_jandex",
          ":org_jboss_logging_jboss_logging",
          ":org_jboss_resteasy_resteasy_jaxrs",
          ":org_jboss_resteasy_resteasy_multipart_provider",
          ":org_jboss_spec_javax_servlet_jboss_servlet_api_3_0_spec",
          ":org_jboss_spec_javax_transaction_jboss_transaction_api_1_2_spec",
          ":org_jboss_spec_javax_ws_rs_jboss_jaxrs_api_2_0_spec",
          ":org_keycloak_keycloak_core",
          ":org_keycloak_keycloak_server_spi",
          ":org_keycloak_keycloak_server_spi_private",
          ":org_keycloak_keycloak_services",
          ":org_liquibase_liquibase_core",
          ":org_twitter4j_twitter4j_core",
          ":xml_apis_xml_apis",
      ],
  )


  native.java_library(
      name = "antlr_antlr",
      visibility = ["//visibility:public"],
      exports = ["@antlr_antlr//jar"],
  )


  native.java_library(
      name = "org_glassfish_javax_json",
      visibility = ["//visibility:public"],
      exports = ["@org_glassfish_javax_json//jar"],
  )


