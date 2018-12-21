FROM ubuntu:18.04

RUN set -e -x ;\
    apt-get -y update ;\
    apt-get -y upgrade ;\
    apt-get -y install golang-go git

RUN set -e -x ;\
    mkdir -p /go/src/github.com/bitly

ENV GOPATH=/go

RUN go get -u github.com/golang/dep/cmd/dep

ADD . /go/src/github.com/bitly/oauth2_proxy/

RUN set -e -x ;\
    cd /go/src/github.com/bitly/oauth2_proxy ;\
    /go/bin/dep ensure ;\
    go install github.com/bitly/oauth2_proxy

FROM ubuntu:18.04
RUN set -e -x ;\
    apt-get -y update ;\
    apt-get -y upgrade ;\
    apt-get -y install ca-certificates
COPY --from=0 /go/bin/oauth2_proxy /usr/bin/oauth2_proxy
CMD ["oauth2_proxy"]
