# This is a multi-stage Dockerfile and requires >= Docker 17.05
# https://docs.docker.com/engine/userguide/eng-image/multistage-build/
FROM golang:1.11 as builder

RUN mkdir -p $GOPATH/src/github.com/kindlyops/mappamundi/worker
WORKDIR $GOPATH/src/github.com/kindlyops/mappamundi/worker

ADD . .
RUN go get -u github.com/golang/dep/cmd/dep
RUN dep ensure -vendor-only
RUN dep ensure -add github.com/kindlyops/mappamundi/havenapi/keycloak
RUN go build -o app main.go

FROM havengrc-docker.jfrog.io/kindlyops/reporter:latest
LABEL maintainer="Kindly Ops, LLC <support@kindlyops.com>"
RUN useradd -ms /bin/bash havenuser && chown -R havenuser:havenuser /home/havenuser
WORKDIR /home/havenuser

COPY --from=builder /go/src/github.com/kindlyops/mappamundi/worker/app .
RUN chown -R havenuser:havenuser /home/havenuser
RUN chgrp -R 0 /home/havenuser &&chmod -R g=u /home/havenuser

CMD exec /home/havenuser/app
