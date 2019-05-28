FROM havengrc-docker.jfrog.io/unleashorg/unleash-server:3.2

RUN npm install @exlinc/keycloak-passport
RUN npm install basic-auth


COPY *.js ./
COPY frontend /
