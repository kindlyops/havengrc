FROM havengrc-docker.jfrog.io/kindlyops/unleash-docker:3.1.1

RUN npm install @exlinc/keycloak-passport
RUN npm install basic-auth



COPY *.js ./
COPY frontend /