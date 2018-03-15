FROM gobuffalo/buffalo:latest

RUN mkdir -p $GOPATH/src/github.com/gobuffalo/x
WORKDIR $GOPATH/src/github.com/gobuffalo/x

ADD . .

RUN go get -u gopkg.in/gomail.v2
RUN go test -v -race ./...
