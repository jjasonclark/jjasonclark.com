---
layout: post
date: 2012-04-30
comments: true
description: How to setup npm to work behind a web proxy
categories: node, npm, howto
keywords: node.js, npm, proxy, setup
summary: For those who, like me, are behind a corporate web proxy, setting up Node.js and using `npm` can be a real pain. I thought that the web proxy settings would be like the rest of the unix world and require me to set the `HTTP_PROXY` and `HTTPS_PROXY` environment variables. Although I just cloned the Node repository from [Github](https://github.com/joyent/node) so they are already setup. What gives?
title: How to setup Node.js and Npm behind a corporate web proxy
permalink: /how-to-setup-node-behind-web-proxy
---

# How to setup Node.js and Npm behind a corporate web proxy

For those who, like me, are behind a corporate web proxy, setting up Node.js and using `npm` can be a real pain. I thought that the web proxy settings would be like the rest of the unix world and require me to set the `HTTP_PROXY` and `HTTPS_PROXY` environment variables. Although I just cloned the Node repository from [Github](https://github.com/joyent/node) so they are already setup. What gives?

A little searching and I discover that `npm` uses a configuration file and it can be added to via the command line `npm config set ...`. The key to getting it right is the spelling of the settings. This has bit me so many times now! Getting `npm` to work behind a proxy requires setting the `proxy` and `https-proxy` settings. The key is noticing the `-` (dash) is not an `_` (underscore).

So the full procedure is install [Node.js](http://nodejs.com) via the installer or source.
Open an command prompt or terminal session and run the following commands to configure `npm` to work with your web proxy. The commands use `proxy.company.com` as the address and `8080` as the port.

{% highlight sh %}
npm config set proxy http://proxy.company.com:8080
npm config set https-proxy http://proxy.company.com:8080
{% endhighlight %}

Why the developers of `npm` choose to use a dash instead of an underscore like the rest of the unix work is beyond me. Maybe someone will add in an alias so setting `https_proxy` will have the same effect as `https-proxy`.
