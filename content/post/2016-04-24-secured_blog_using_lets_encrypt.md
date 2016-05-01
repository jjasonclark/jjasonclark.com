+++
comments = true
date = "2016-04-24"
description = "Thanks to Let’s Encrypt and Caddy, this blog is now served via HTTPS. Here is how I converted from static hosting on Amazon’s S3 to a Digital Ocean instance running Caddy in a Docker container."
draft = false
summary = "I finally did it! I joined the secure web. Thanks to Let’s Encrypt and Caddy, this blog is now served via HTTPS. Caddy makes using Let’s Encrypt a single line change in a config file. It could not get simpler than that. Here is how I converted from static hosting on Amazon’s S3 to a Digital Ocean instance running Caddy in a Docker container."
tags = ["ssl", "blog", "caddy", "lets encrypt"]
title = "Secured blog using Let's Encrypt"
url = "/secured_blog_using_lets_encrypt"
+++

I finally did it! I joined the secure web. Thanks to Let's Encrypt and Caddy, this blog is now served via HTTPS. Caddy makes using Let's Encrypt a single line change in a config file. It could not get simpler than that. Here is how I converted from static hosting on Amazon's S3 to a Digital Ocean instance running Caddy in a Docker container.

## What I did

1. Create Digital Ocean droplet
1. Updated DNS entries to point to droplet
1. Install Docker
1. Create a Docker image for the server
1. Ran the Docker image with ports 80 and 443 exposed with restart always

### Create Digital Ocean droplet

My journey to convert from my old hosting method to using Caddy was relatively painless. I did cheat a bit by using Docker to create my new server instead of trying to install everything myself. Going from static hosting via S3 to a Docker image is simple. I choose to host my blog on Digital Ocean because of pricing. I get very little traffic and their $5/month hosting was even cheaper than Amazon's EC2. Ubuntu 16.04 LTS just came out too and DO already had it as a choice for pre-setup server images. I picked that as my image and was setup faster than I could return with a fresh cup of coffee.

### Updated DNS entries

My DNS timeout was already set to an hour timeout from an earlier change. So once I had the new droplet's IP address I updated my DNS entry. This would need to be setup before Let's Encrypt's servers try to callback to my blog server verify the server. And since I already had entries pointing else where I would need to wait for the timeout period to expire before I was sure the correct server would be contacted.

### Install Docker

Followed instructions at https://docs.docker.com/engine/installation/linux/ubuntulinux/. The simplified version is add Docker's package repositry to the server's list. Then install the `docker-engine` package.

{{< highlight shell >}}
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" >> /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install docker-engine linux-image-extra-$(uname -r)
{{< /highlight >}}

### Create Docker image for blog server

I created a Docker image for my blog using a image for the Caddy server as the base. I picked an Alpine based one at [zzrot/alpine-caddy](https://hub.docker.com/r/zzrot/alpine-caddy/). All I needed to do was add my blog files and configure a Caddyfile.

{{< highlight docker >}}
FROM zzrot/alpine-caddy
MAINTAINER Jason Clark <jason@jjcconsultingllc.com>

EXPOSE 80 443
COPY docker/Caddyfile /etc/Caddyfile
COPY public/ /var/www/html/
{{< /highlight >}}

**From:** https://github.com/jjasonclark/jjasonclark.com/blob/master/Dockerfile

I tried to test this out locally using Docker for Mac since I'm using the beta native client. I could never get it to work. The logs would show the server starting and give it's message about what port its listening to, but would not actually accept any connections. I just had to trust it would work when deployed.

### Set server to always run blog image

Getting a docker image to always restart when the server goes down is as simple as a command line flag. This is _sometimes_ preferable to actually creating a real system service setup for the image. As long as you don't need all the extra commands that system service needs this method should be fine. I used the following command to get the image running.

{{< highlight shell >}}
docker run -d --name blog \
  --restart always \
  -p 80:80 -p 443:443 \
  -v $(pwd)/lets_encrypt:/root/.caddy \
  jjasonclark/jjasonclark.com
{{< /highlight >}}
