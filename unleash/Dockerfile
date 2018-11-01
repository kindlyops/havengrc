FROM havengrc-docker.jfrog.io/kindlyops/unleash-docker:3.1.1

# needed for keycloak-gatekeeper
RUN apk add --no-cache ca-certificates

RUN npm install @exlinc/keycloak-passport
RUN npm install basic-auth



COPY *.js ./
COPY frontend /
ADD keycloak-proxy-linux-amd64 /opt/keycloak-gatekeeper

# TODO: cleanly run CMD node index.js as well as keycloak-gatekeeper
# ENTRYPOINT [ "/opt/keycloak-gatekeeper" ]
