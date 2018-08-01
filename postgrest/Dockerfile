FROM        havengrc-docker.jfrog.io/postgrest/postgrest:v0.5.0.0
MAINTAINER  Kindly Ops, LLC <support@kindlyops.com>
COPY        postgrest/config /config
USER root
RUN addgroup --system havenuser && adduser --system havenuser && adduser havenuser havenuser
RUN chown -R havenuser:0 /config && \
	chmod -R g+rw /config && \
	chown -R havenuser:0 /usr/local/bin/postgrest && \
	chmod -R g+rw /usr/local/bin/postgrest && \
	chown -R havenuser:0 /tmp && \
	chmod -R g+rw /tmp
USER 1000
ENV         ENV_VERBOSITY 无
ENV         DATABASE_NAME mappamundi_dev
ENV         DATABASE_USERNAME postgres
ENV         DATABASE_PASSWORD postgres
ENV         DATABASE_HOST postgres
ENV         HAVEN_JWK_PATH /keycloak-dev-public-key.json
ENV         PGRST_JWT_AUD_CLAIM havendev
ENV         PGRST_SERVER_PROXY_URI http://localhost:8180
EXPOSE 8180
CMD postgrest "/config"
