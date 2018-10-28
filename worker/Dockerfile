# This is a multi-stage Dockerfile and requires >= Docker 17.05
# https://docs.docker.com/engine/userguide/eng-image/multistage-build/
FROM golang:1.11 as builder

RUN mkdir -p $GOPATH/src/github.com/kindlyops/mappamundi
WORKDIR $GOPATH/src/github.com/kindlyops/mappamundi

ADD . .
WORKDIR $GOPATH/src/github.com/kindlyops/mappamundi/worker
RUN go get -u github.com/golang/dep/cmd/dep
RUN dep ensure -vendor-only
RUN go build -o app main.go

FROM kindlyops/reporter:latest
LABEL maintainer="Kindly Ops, LLC <support@kindlyops.com>"
RUN useradd -ms /bin/bash havenuser && chown -R havenuser:havenuser /home/havenuser
WORKDIR /home/havenuser

COPY --from=builder /go/src/github.com/kindlyops/mappamundi/worker/app .
COPY --from=builder /go/src/github.com/kindlyops/mappamundi/worker/compilereport .
RUN chown -R havenuser:havenuser /home/havenuser
RUN chgrp -R 0 /home/havenuser && chmod -R g=u /home/havenuser
USER havenuser
CMD exec /home/havenuser/app
