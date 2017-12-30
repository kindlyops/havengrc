FROM havengrc-docker.jfrog.io/perl:latest
RUN apt-get clean && apt-get update && apt-get -y install vim postgresql-client
RUN cpan inc::latest
RUN cpan -fi App::Sqitch
RUN cpan DBD::Pg
WORKDIR /src
ADD run-sqitch.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/run-sqitch.sh"]
