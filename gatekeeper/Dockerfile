FROM keycloak/keycloak-gatekeeper:6.0.1

ARG COMMIT=""

LABEL commit=${COMMIT} \
    maintainer="Kindly Ops, LLC <support@kindlyops.com>"

ENV DISCOVERY_URL http://dev.havengrc.com/auth/realms/havendev
ENV CLIENT_SECRET df2ba720-1d10-4d85-940a-6df77ef69baa
ENV UPSTREAM_URL http://dev.havengrc.com/

RUN apk add --no-cache openssl

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY gatekeeper.tmpl /opt/gatekeeper.tmpl

ENTRYPOINT ["/usr/local/bin/dockerize", "-template", "/opt/gatekeeper.tmpl:/opt/gatekeeper.yaml", "/opt/keycloak-gatekeeper", "--config", "/opt/gatekeeper.yaml", "--verbose"]