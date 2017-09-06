FROM havengrc-docker.jfrog.io/openjdk:8u121-jre-alpine
MAINTAINER Kindly Ops, LLC <support@kindlyops.com>

ENV PLANTUML_VERSION 8055
ENV LANG en_US.UTF-8
RUN apk add --no-cache graphviz ttf-droid ttf-droid-nonlatin curl \
    && mkdir /app \
    && curl -L https://sourceforge.net/projects/plantuml/files/plantuml.${PLANTUML_VERSION}.jar/download -o /app/plantuml.jar \
    && apk del curl

ENTRYPOINT [ "java", "-jar", "/app/plantuml.jar" ]
CMD [ "-h" ]
