FROM golang:alpine as builder

RUN apk add --no-cache git gcc libc-dev && go get github.com/Kong/go-pluginserver

COPY ./plugins/*.go /opt
RUN go build -buildmode plugin -o /opt/go-hello.so /opt/go-hello.go

######
FROM kong:latest

COPY --from=builder /go/bin/go-pluginserver /usr/local/bin/
COPY --from=builder /opt/*.so /opt

EXPOSE 8000 8001 8443 8444