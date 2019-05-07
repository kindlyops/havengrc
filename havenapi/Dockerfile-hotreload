FROM gobuffalo/buffalo:v0.14.3

RUN mkdir -p $GOPATH/src/github.com/kindlyops/havengrc/havenapi
WORKDIR $GOPATH/src/github.com/kindlyops/havengrc/havenapi
ADD ./havenapi/ $GOPATH/src/github.com/kindlyops/havengrc/havenapi

EXPOSE 3000
ENV ADDR 0.0.0.0
ENV GO111MODULE=on
CMD exec buffalo dev
