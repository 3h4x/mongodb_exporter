FROM       golang:alpine as builder

RUN apk --no-cache add curl git make perl gcc musl-dev
RUN curl -s https://glide.sh/get | sh
ADD . /go/src/github.com/dcu/mongodb_exporter/
RUN go get github.com/percona/mongodb_exporter
RUN cd /go/src/github.com/dcu/mongodb_exporter && make

FROM       alpine:3.4
EXPOSE     9001

RUN apk add --update ca-certificates
COPY --from=builder /go/src/github.com/dcu/mongodb_exporter/mongodb_exporter /usr/local/bin/mongodb_exporter

EXPOSE      9216
ENTRYPOINT         [ "/bin/mongodb_exporter" ]
