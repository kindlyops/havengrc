FROM havengrc-docker.jfrog.io/kindlyops/sqitch:latest
USER root
RUN addgroup --system havenuser && adduser --system havenuser && adduser havenuser havenuser
RUN chown -R havenuser:0 /src && \
    chmod -R g+rw /src && \
		chown -R havenuser:0 /tmp && \
		chmod -R g+rw /tmp
USER 1000
ADD sqitch.conf sqitch.plan verify deploy revert /src/
