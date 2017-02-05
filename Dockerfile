FROM jojomi/hugo:latest
MAINTAINER Jason Clark <jason@jjasonclark.com>

RUN apk add --update py-pygments && rm /var/cache/apk/*

EXPOSE 1313

WORKDIR /src
CMD /usr/bin/hugo --cleanDestinationDir -d public