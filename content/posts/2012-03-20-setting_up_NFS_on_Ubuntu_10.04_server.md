---
layout: post
date: 2012-03-20
comments: true
description: How to get a base install Ubuntu 10.04 server to run NFS. Includes setting up IPTables rules.
categories: ubuntu, unix, howto, nfs, iptables
tags: ubuntu, unix, howto, nfs, iptables
summary: I'm currently working on improving my knowledge of UNIX networking. One of the common tasks for a server is acting as an NFS server. These are the steps I take on an Ubuntu 10.04 server to setup NFS.
title: Setting up NFS on Ubuntu 10.04 Server
url: /setting_up_NFS_on_Ubuntu_10.04_server
---

I'm currently working on improving my knowledge of UNIX networking. One of the common tasks for a server is acting as an NFS server. These are the steps I take on an Ubuntu 10.04 server to setup NFS.

The following assumes you have already setup Ubuntu and can access the network. Do all the following as the root user.

## Install the NFS server package
Run the following commands to install NFS server and rpcbind

    apt-get install nfs-kernel-server
    apt-get install rpcbind

## Setup IPTables to restore rules at startup and save rules at shutdown
Create the following two files

* /etc/network/if-pre-up.d/iptablesload

        #!/bin/sh
        iptables-restore < /etc/iptables.rules
        exit 0

* /etc/network/if-post-down.d/iptablessave

        #!/bin/sh
        iptables-save -c > /etc/iptables.rules
        if [ -f /etc/iptables.downrules ]; then
            iptables-restore < /etc/iptables.downrules
        fi
        exit 0

Give both scripts execute permissions and run them

    chmod +x /etc/network/if-pre-up.d/iptablesload
    chmod +x /etc/network/if-post-down.d/iptablessave
    /etc/network/if-post-down.d/iptablessave
    /etc/network/if-pre-up.d/iptablesload

## Add IPTable rules to allow NFS and RPCBind traffic
Run the following commands

    iptables -A INPUT -m state --state NEW -p udp --dport 111 -j ACCEPT
    iptables -A INPUT -m state --state NEW -p tcp --dport 111 -j ACCEPT
    iptables -A INPUT -m state --state NEW -p tcp --dport 2049 -j ACCEPT
    iptables -A INPUT -m state --state NEW -p tcp --dport 32803 -j ACCEPT
    iptables -A INPUT -m state --state NEW -p udp --dport 32769 -j ACCEPT
    iptables -A INPUT -m state --state NEW -p tcp --dport 892 -j ACCEPT
    iptables -A INPUT -m state --state NEW -p udp --dport 892 -j ACCEPT
    iptables -A INPUT -m state --state NEW -p tcp --dport 875 -j ACCEPT
    iptables -A INPUT -m state --state NEW -p udp --dport 875 -j ACCEPT
    iptables -A INPUT -m state --state NEW -p tcp --dport 662 -j ACCEPT
    iptables -A INPUT -m state --state NEW -p udp --dport 662 -j ACCEPT
    /etc/network/if-post-down.d/iptablessave

## Setup ports for NFS
Edit the file `/etc/default/nfs-kernel-server` and add or uncomment the following lines

    LOCKD_TCPPORT=32803
    LOCKD_UDPPORT=32769
    MOUNTD_PORT=892
    RQUOTAD_PORT=875
    STATD_PORT=662
    STATD_OUTGOING_PORT=2020

## Add your domain for IdMap service
Edit the file `/etc/idmapd.conf` and change the value for `Domain` to be your domain.

## Create first export
Create your first exported directory

    mkdir -p /export/first

Setup NFS to export the directory by editing the file `/etc/exports`. Add the following line

    /export/first *(rw,async,no_subtree_check,no_root_squash)

Update NFS exported files by running `exportfs -a`

## Restart NFS and networking
Restart via the following commands

    /etc/init.d/nfs-kernel-server restart
    /etc/init.d/networking restart

## Verify it all works
Run `rpcinfo -p` and verify that the following services are listed

    mountd
    nlockmgr
    nfs
    portmapper

## Further reading
These are the help pages I read to figure most of this out. They are from the Ubuntu community documentation and are definitely worth reading.

* [Setting Up NFS How To](https://help.ubuntu.com/community/SettingUpNFSHowTo)
* [IPTables How To](https://help.ubuntu.com/community/IptablesHowTo)
