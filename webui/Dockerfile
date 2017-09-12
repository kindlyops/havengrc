FROM        scratch
MAINTAINER  Kindly Ops, LLC <support@kindlyops.com>
ADD         vendor/linux/caddy caddy
ADD         build/ .
ADD         Caddyfile config/Caddyfile
ENV         ENV_VERBOSITY 无
ENTRYPOINT  ["/caddy"]
CMD         ["-agree", "-conf", "/config/Caddyfile"]
