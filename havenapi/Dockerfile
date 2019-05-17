# This is a multi-stage Dockerfile and requires >= Docker 17.05
# https://docs.docker.com/engine/userguide/eng-image/multistage-build/
FROM gobuffalo/buffalo:v0.14.3 as builder

RUN mkdir -p $GOPATH/src/github.com/kindlyops/havengrc/havenapi
WORKDIR $GOPATH/src/github.com/kindlyops/havengrc/havenapi

# this will cache the npm install step, unless package.json changes
#ADD package.json .
#ADD yarn.lock .
#RUN yarn install --no-progress
ADD . .
ENV GO111MODULE=on
RUN buffalo build --static -o /bin/app

FROM alpine
RUN apk add --no-cache bash
RUN apk add --no-cache ca-certificates
RUN addgroup -S havenuser && adduser -S -g havenuser havenuser && chown -R havenuser:havenuser /home/havenuser
# Comment out to run the binary in "production" mode:
# ENV GO_ENV=production

WORKDIR /home/havenuser

COPY --from=builder /bin/app .
RUN chown -R havenuser:havenuser /home/havenuser
RUN chgrp -R 0 /home/havenuser &&chmod -R g=u /home/havenuser
EXPOSE 3000
ENV GO111MODULE=on

# Comment out to run the migrations before running the binary:
# CMD /bin/app migrate; /bin/app
CMD exec /home/havenuser/app
