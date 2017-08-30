FROM        havengrc-docker.jfrog.io/node:6.2.2
MAINTAINER  Kindly Ops, LLC <support@kindlyops.com>
VOLUME ["/docs"]
WORKDIR /docs
RUN npm install gitbook-cli -g && /usr/local/bin/gitbook install
ENTRYPOINT ["/usr/local/bin/gitbook"]
