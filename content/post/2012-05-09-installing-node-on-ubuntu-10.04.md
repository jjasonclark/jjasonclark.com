---
date: 2012-05-09
comments: true
description: Installing Node.js on Ubuntu 10.04 server
categories:
  - ubuntu
  - unix
  - howto
  - node
  - javascript
tags:
  - ubuntu
  - unix
  - howto
  - node
  - javascript
summary: Most of the guides I find on how to install [Node.js][1] on Ubuntu are not about installing the currently released version, instead they focus on installing the latest development release. I think this is the case because they assume the reader is familiar with doing software installs on unix from source. I'm coming from a Windows word were installing from the source is almost never done. This guide is for someone relatively new to unix installation or to Ubuntu server setup.
title: Installing Node.js on Ubuntu 10.04 server
url: /installing-node-on-ubuntu-10.04/
---

Most of the guides I find on how to install [Node.js][1] on Ubuntu are not about installing the currently released version, instead they focus on installing the latest development release. I think this is the case because they assume the reader is familiar with doing software installs on unix from source. I'm coming from a Windows word were installing from the source is almost never done. This guide is for someone relatively new to unix installation or to Ubuntu server setup.

Installing [Node.js][1] from source is done in 3 basic steps. Step 1 is setting up your system to configure and build [Node.js][1]. Step 2 is getting a copy of the [Node.js][1] source. And the last step is building the correct version of [Node.js][1]. Some of the commands need root permissions to execute. For those commands I use the `sudo` filter command to elevate the current user to root permissions.

## Step 1: Setting up Node.js dependencies
Run the following command to install the dependencies. These dependencies are needed to build an configure [Node.js][1] without any errors. On a fresh install of Ubuntu 10.04 you will need all of the components. If you happen to already have some of these items install this command will skip it without error.

    sudo apt-get install -y g++ curl libssl-dev apache2-utils git-core pkg-config

## Step 2: Creating a local copy of the Node.js source
The [Node.js][1] source is located on [Github][2]. Issue the following commands to create a local copy of the full version history. This will include the current production release, as well as, the current development release. If you have a bare system, you might not have created a "source" directory yet for all of your projects. If you have then you can skip the first 2 commands.

    mkdir source
    cd source
    git clone https://github.com/joyent/node.git
    cd node

## Step 3: Configuring and building Node.js
For this step you need to find out what the most resent production release version number is. At the time of writing [Node.js][1] is on the `0.6.17` release. The copy of the source includes this version under the tag with a similar name. The following commands will select the production version and then build it. Remember to change the first command to have the version you want. (Don't forget the leading 'v') After the first command `git` will issue a message that looks like a warning or a failure. The message about the "detached HEAD" is ok to ignore. The message is explaining that you have the master pointer pointing to a commit in the middle of the history. This is acceptable because you are not building the latest development version.

    git checkout v0.6.17
    ./configure
    make && sudo make install

[1]: http://nodejs.org "Node.js"
[2]: http://github.com "Github"
