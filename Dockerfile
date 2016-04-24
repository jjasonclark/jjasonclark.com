FROM zzrot/alpine-caddy
MAINTAINER Jason Clark <jason@jjcconsultingllc.com>

EXPOSE 80
COPY docker/Caddyfile /etc/Caddyfile
COPY public/ /var/www/html/
