# This is a multi-stage Dockerfile and requires >= Docker 17.05
# https://docs.docker.com/engine/userguide/eng-image/multistage-build/
FROM golang:1.12.4 as builder

RUN mkdir -p $GOPATH/src/github.com/kindlyops/havengrc
WORKDIR $GOPATH/src/github.com/kindlyops/havengrc

ADD . .
WORKDIR $GOPATH/src/github.com/kindlyops/havengrc/worker
ENV GO111MODULE=on
RUN go build -o app main.go

FROM kindlyops/reporter:worker-base
ARG COMMIT=""

LABEL commit=${COMMIT}
LABEL maintainer="Kindly Ops, LLC <support@kindlyops.com>"
ENV COMMIT_SHA=${COMMIT}
ENV SENTRY_RELEASE=${COMMIT}

RUN useradd -ms /bin/bash havenuser && chown -R havenuser:havenuser /home/havenuser
WORKDIR /home/havenuser

COPY --from=builder /go/src/github.com/kindlyops/havengrc/worker/app .
COPY --from=builder /go/src/github.com/kindlyops/havengrc/worker/compilereport /usr/local/bin/
RUN chown -R havenuser:havenuser /home/havenuser
RUN chgrp -R 0 /home/havenuser && chmod -R g=u /home/havenuser
USER havenuser
CMD exec /home/havenuser/app
