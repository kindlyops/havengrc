FROM havengrc-docker.jfrog.io/kindlyops/sqitch:latest
USER root
ADD sqitch.conf sqitch.plan verify deploy revert /src/
RUN addgroup --system havenuser && adduser --system havenuser && adduser havenuser havenuser
RUN chown -R havenuser:0 /src && \
    chmod -R g+rw /src && \
		chown -R havenuser:0 /tmp && \
		chmod -R g+rw /tmp && \
		sqitch config --user user.name '史强' && \
		sqitch config --user user.email 'support@kindlyops.com'
ADD sqitch/sqitch.patch .
# slam patch for https://github.com/theory/sqitch/issues/358 that is blowing us up in sqitch 0.9996 
# https://github.com/theory/sqitch/issues/358
RUN patch -p 4 /usr/local/lib/perl5/site_perl/5.26.1/App/Sqitch/Engine/pg.pm sqitch.patch
USER havenuser
