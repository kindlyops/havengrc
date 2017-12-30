FROM havengrc-docker.jfrog.io/kindlyops/sqitch:latest
USER root
ADD sqitch.conf sqitch.plan verify deploy revert /src/
RUN addgroup --system havenuser && adduser --system havenuser && adduser havenuser havenuser
RUN chown -R havenuser:0 /src && \
    chmod -R g+rw /src && \
		chown -R havenuser:0 /usr/local/bin/*sqitch* && \
		chmod -R g+rw /usr/local/bin/*sqitch* && \
		chown -R havenuser:0 /tmp && \
		chmod -R g+rw /tmp
USER havenuser
