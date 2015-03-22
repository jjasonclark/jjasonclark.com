---
layout: post
date: 2012-08-17
comments: true
description: Setting up a Mac for remote pairing via Tmux
categories: ruby, macosx, unix, pairing
keywords: macosx, setup, ruby, unix, tmux, pairing
summary: How to setup a Mac for remote pairing via Tmux. Including some scripts to help automate the process.
title: Remote pairing with SSH and Tmux on a Mac
url: /Remote-Pairing-with-SSH-and-Tmux-on-a-Mac
---

Pair programming is a wonderful thing. It can get you out of your programming jam faster than anything. If you haven't tried pair programming, then you need too. It is just that simple. The easiest way to pair program is to have everyone sit down at the computer together. Typically one person "drives" and the other helps out. If you cannot sit down with your pair partner in person then remote pairing though SSH and [Tmux][2] works great.

It is easy to setup your computer to support remote pairing.

## Install Tmux
Install Tmux using Homebrew.

{% highlight sh %}
brew install tmux
{% endhighlight %}

You might want to change the configuration. Take a look at my [.tmux.conf][1]. It's a good starter configuration using `ctrl+/` as the Tmux key.

## Setup user account for pair partner
Next thing you need to do is setup a user account for others to SSH into your computer with. You can reuse the same account for all your pair programming instead of an account per partner. In my case I created a user named `remotepair`. This is setup like any other user on your Mac; you use the "User & Groups" system preference.

## Allow user to connect via SSH
Once the user is setup you need to allow the user to log in via SSH. In the "Sharing" system preference enable "Remote Login". And then add the following to your `/etc/sshd_config` file.

    Match User remotepair
        X11Forwarding no
        AllowTcpForwarding no
        ForceCommand /usr/local/bin/tmux -S /tmp/pair attach -t workenv

Change the first line to match the user account name you created. The last line connects the user to your Tmux session.

## Setting up the shared Tmux session
The secret to getting a shared session working with Tmux is to know where the socket is. You can use the `-S` argument to specify this location. I have created a script to setup my environment and include this option. The following is the script I use for my work project. It sets up 3 windows in a named session using the socket path of `/tmp/pair`. This is the same path from `/etc/sshd_config`'s force command.

{% highlight sh %}
#!/bin/sh

tmux -S /tmp/pair has-session -t workenv
if [[ $? == 1 ]] ; then
    pushd /Volumes/Analog/super-banner
    tmux -S /tmp/pair new-session -d -s workenv -n Vim
    tmux -S /tmp/pair new-window -t workenv -n Super-Banner
    cd /Volumes/Analog/cookbooks
    tmux -S /tmp/pair new-window -t workenv -n Cookbooks
    tmux -S /tmp/pair select-window -t workenv:Vim
    popd
fi
tmux -S /tmp/pair -2 attach -t workenv
{% endhighlight %}

## Enable pair partner to join the shared session
Finally I have created a script to set the needed permissions on the shared socket. Additionally I enable and disable the login ability of the pair partner account.

{% highlight sh %}
#! /bin/sh

if [ "enable" = "$1" ]; then
    chmod 777 /tmp/pair
    sudo dscl . -create /Users/remotepair UserShell /bin/bash
else
    chmod 770 /tmp/pair
    sudo dscl . -create /Users/remotepair UserShell /usr/bin/false
fi
{% endhighlight %}

## Pair for the win
Tell your pair partner to connect to your computer using your pairing account name.

{% highlight sh %}
ssh remotepair@jjasonclark.com
{% endhighlight %}

Thats it! Your all setup to pair via SSH and Tmux. Head over to [Ruby Pair][3] and try it out.

[1]: /assets/tmux.conf.txt
[2]: http://tmux.sourceforge.net/
[3]: http://rubypair.com/
