FROM zzrot/alpine-caddy
MAINTAINER Jason Clark <jason@jjasonclark.com>

EXPOSE 80 443
COPY docker/Caddyfile /etc/Caddyfile
COPY public/ /var/www/html/
