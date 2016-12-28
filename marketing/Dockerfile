FROM        scratch
MAINTAINER  Kindly Ops, LLC <support@kindlyops.com>
ADD         marketing/vendor/linux/caddy caddy
ADD         marketing/ .
ADD         marketing/Caddyfile config/Caddyfile
ENV         ENV_VERBOSITY 无
ENTRYPOINT  ["/caddy"]
CMD         ["-agree", "-conf", "/config/Caddyfile"]
