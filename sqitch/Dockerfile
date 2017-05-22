FROM havengrc-docker.jfrog.io/perl:latest
RUN apt-get clean && apt-get update && apt-get -y install vim postgresql-client
RUN cpan inc::latest
RUN cpan App::Sqitch
RUN cpan DBD::Pg
VOLUME ["/src"]
WORKDIR /src
ENTRYPOINT ["/usr/local/bin/sqitch"]
