FROM        alpine
MAINTAINER  Kindly Ops, LLC <support@kindlyops.com>
RUN apk add --no-cache bash ca-certificates libcap
RUN addgroup -S havenuser && adduser -S -g havenuser havenuser
WORKDIR /home/havenuser
RUN         mkdir .caddy
ADD         vendor/linux/caddy caddy
ADD         build/ .
ADD         Caddyfile .
ENV         ENV_VERBOSITY 无
ENV         HOME /home/havenuser
RUN chown -R havenuser:havenuser /home/havenuser && chgrp -R 0 /home/havenuser && chmod -R g=u /home/havenuser
RUN setcap CAP_NET_BIND_SERVICE=+eip /home/havenuser/caddy
USER havenuser
ENTRYPOINT  ["/home/havenuser/caddy"]
CMD         ["-agree"]
