# you can't run as root on openshift. set up a non-root user
FROM        havengrc-docker.jfrog.io/contribsys/faktory:0.9.0
RUN addgroup -S havenuser && adduser -S -g havenuser havenuser
WORKDIR /home/havenuser
ENV         HOME /home/havenuser
RUN mkdir -p /home/havenuser/.faktory/db
RUN chown -R havenuser:havenuser /home/havenuser && chgrp -R 0 /home/havenuser && chmod -R g=u /home/havenuser
RUN chown -R havenuser:havenuser /var/lib/faktory && chgrp -R 0 /var/lib/faktory && chmod -R g=u /var/lib/faktory
RUN chown -R havenuser:havenuser /etc/faktory && chgrp -R 0 /etc/faktory && chmod -R g=u /etc/faktory
USER havenuser