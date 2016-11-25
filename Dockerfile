FROM perl:latest
RUN apt-get clean && apt-get update && apt-get -y install vim postgresql-client
RUN cpan inc::latest
RUN cpan App::Sqitch
RUN cpan DBD::Pg
ADD sqitch.conf sqitch.plan verify deploy revert /src/
VOLUME ["/src"]
WORKDIR /src
ENTRYPOINT ["/usr/local/bin/sqitch"]
