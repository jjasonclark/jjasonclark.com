FROM alpine:3.10
MAINTAINER Jason Clark <jason@jjasonclark.com>

RUN apk add --update libc6-compat libstdc++ ca-certificates \
    && rm /var/cache/apk/*

ADD https://github.com/gohugoio/hugo/releases/download/v0.61.0/hugo_extended_0.61.0_Linux-64bit.tar.gz /hugo_download/hugo.tar.gz
RUN tar -xf /hugo_download/hugo.tar.gz -C /hugo_download \
    && mv /hugo_download/hugo /usr/bin/hugo \
    && rm -rf /hugo_download

VOLUME /src
VOLUME /output

WORKDIR /src
CMD /usr/bin/hugo --cleanDestinationDir -d public
