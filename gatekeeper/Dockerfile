FROM keycloak/keycloak-gatekeeper:6.0.1

ARG COMMIT=""

LABEL commit=${COMMIT} \
    maintainer="Kindly Ops, LLC <support@kindlyops.com>"

ENV DISCOVERY_URL ""
ENV CLIENT_SECRET ""
ENV UPSTREAM_URL ""
ENV TLS_PRIVATE_KEY ""
ENV TLS_CERT ""
ENV REDIRECTION_URL ""
ENV SECURE_COOKIE ""

RUN addgroup -S havenuser && adduser -S -g havenuser havenuser

RUN apk add --no-cache openssl curl libcap

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN mkdir /opt/config
COPY vendor/linux/caddy /opt
COPY Caddyfile.tmpl /opt/
COPY config/gatekeeper.tmpl /opt/config/gatekeeper.tmpl
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chown -R havenuser:havenuser /opt && chgrp -R 0 /opt && chmod -R g=u /opt
RUN setcap CAP_NET_BIND_SERVICE=+eip /opt/keycloak-gatekeeper
RUN setcap CAP_NET_BIND_SERVICE=+eip /opt/caddy
# set up nsswitch.conf for Go's "netgo" implementation
# - https://github.com/golang/go/blob/go1.9.1/src/net/conf.go#L194-L275
RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf
USER havenuser

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]