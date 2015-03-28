---
layout: post
date: 2013-11-27
comments: true
description: Use Avahi-daemon on Linux to broadcast your web apps to your Mac. Works great with VMs too.
categories: vm, linux, development
tags: vm, linux
summary: How to setup Bonjour broadcast to connect your Linux servers to your Macs for easy access while developing. Safari automatically adds the web servers that are broadcasting on your local network. Linux servers will broadcast once the Avahi server is installed.
title: Avahi helps hosts connect to VMs
url: /avahi_helps_hosts_connect_to_vms
---

I create a lot of linux based VMs on my Mac. Sometimes its a bit hard to keep track of which machines have port forwarding or what their IPs are. I found a great solution to the problem: [Bonjour][]. This is the Zeroconf implementation for Macs. It allows a machine to broadcast what services it has. For web development you can use it to broadcast the web server that your working on. Safari on the Mac automatically includes the current services in the bookmarks menu for easy access.

## Mac Setup

In the Safari preference panel select the advanced tab. Check the setting you want.

![Safari preference panel](/assets/safari_preference.png)

## Linux Setup

[Avahi][] is a Linux daemon for Zeroconf. It is incredibly easy to setup and you don't have to reboot your server.

1. Use your distros package manager to install it. For `yum` it is `sudo yum install -y avahi`.

1. Then create a file in the `/etc/avahi/services` directory with a `.service` extension.

{{< highlight xml >}}
<?xml version="1.0" standalone='no'?>
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
  <name replace-wildcards="yes">%h</name>
  <service>
    <type>_http._tcp</type>
    <port>3000</port>
  </service>
</service-group>
{{< /highlight >}}

1. You might need to restart Avahi. It normally picks up the changes as soon as you write the file. To restart it manually run `sudo /etc/init.d/avahi-daemon restart`.

## Getting fancy

[Toa of Mac][1] has some great tips on how to configure a setup with 2 NICs and only broadcast on the private network.

[1]: http://the.taoofmac.com/space/HOWTO/Vagrant
[bonjour]: http://en.wikipedia.org/wiki/Bonjour_(software)
[avahi]: http://avahi.org/
