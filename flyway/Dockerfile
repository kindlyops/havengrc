FROM        havengrc-docker.jfrog.io/boxfuse/flyway:5.0.7-alpine
MAINTAINER  Kindly Ops, LLC <support@kindlyops.com>
RUN addgroup -S havenuser && adduser -S -g havenuser havenuser
RUN apk add --no-cache postgresql-client
WORKDIR /home/havenuser
ADD         sql/* /flyway/sql/
ENV         ENV_VERBOSITY 无
ENV         HOME /home/havenuser
RUN chown -R havenuser:havenuser /flyway && chgrp -R 0 /flyway && chmod -R g=u /flyway
USER havenuser
