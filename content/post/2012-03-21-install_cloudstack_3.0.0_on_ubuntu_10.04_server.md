---
date: 2012-03-21
comments: true
description: How to setup Cloudstack 3.0.0 on Ubuntu 10.04 server
categories:
  - ubuntu
  - unix
  - howto
  - cloudstack
  - cloud
  - vm
tags:
  - ubuntu
  - unix
  - howto
  - cloudstack
  - cloud
  - vm
  - acton
  - xen
  - xenserver
  - citrix
summary: Cloudstack 3.0.0 was release on Febrary 28th 2012. At the time I was trying to install version 2.2 on a VM. I was having a lot of trouble so seeing a new version was wonderful. The following is what I had to do in order to get the system setup. Hopfully this post will help you get Cloudstack running in your environment.
title: Install Cloudstack 3.0.0 on Ubuntu 10.04 Server
url: /install_cloudstack_3.0.0_on_ubuntu_10.04_server/
---

[Cloudstack 3.0.0](https://sourceforge.net/projects/cloudstack/files/CloudStack%20Acton/3.0.0/) was release on [Febrary 28<sup>th</sup> 2012](http://www.cloudstack.org/blog/117-cloudstack-acton-released.html). At the time I was trying to install version 2.2 on a VM. I was having a lot of trouble so seeing a new version was wonderful. The following is what I had to do in order to get the system setup. Hopfully this post will help you get Cloudstack running in your environment.

## Setup procedures
To get started download the [cloud management software](http://sourceforge.net/projects/cloudstack/files/CloudStack%20Acton/3.0.0/CloudStack-3.0.0-1-ubuntu10.04.tar.gz/download) and follow these steps. You will need the [quick install guide](http://sourceforge.net/projects/cloudstack/files/CloudStack%20Acton/3.0.0/CloudStack3.0QuickInstallGuide.pdf/download) to help you through the GUI part of the setup.

This assumes that you have an Ubuntu 10.04 Server running with NFS setup. Additionally you need at least 1 host with XenServer 6 installed. Also, all commands must be run as the root user. For this install I'm going to use the following values. Change the values to what you would use.

    Desktop: myhost
    Management Server: manhost
    XenServer Host: xenhost
    Management IPs: 192.168.0.20 - 192.168.0.29
    Guest IPs: 192.168.0.30 - 39

### Step 1 - Install Ubuntu 10.04 Server with NFS
Follow the guide I wrote on [setting up NFS on ubuntu 10.04 server](/setting_up_NFS_on_Ubuntu_10.04_server)

### Step 2 - Setup SELinux
Install the SElinux package and change to passive mode

    apt-get install selinux-utils
    setenforce permissive

### Step 3 - Create Cloudstack NFS shares
Create two directories for sharing via NFS. I named mine the same as the documentation: primary and secondary. Then share these via NFS.

    mkdir -p /export/primary
    mkdir -p /export/secondary

Edit the file `/etc/exports` to add the following two exports

    /export/primary *(rw,async,no_subtree_check,no_root_squash)
    /export/secondary *(rw,async,no_subtree_check,no_root_squash)

Then run the `exportfs -a` command to expose them.

### Step 4 - Setup Cloudstack management software
Copy the cloud management software to the Ubuntu box. I used `scp` to get this done.

    scp myhost:CloudStack-3.0.0-1-ubuntu10.04.tar.gz manhost:

Once on the management server extract it and run the installer.

    tar xzf CloudStack-3.0.0-1-ubuntu10.04.tar.gz
    cd CloudStack-3.0.0-1-ubuntu10.04
    ./install.sh

The installer will first run `aptitude update` so make sure you have that setup correctly. This should have been done when you setup the Ubuntu box. After updating the components the install script will present you with a prompt to pick what component to install. At this prompt choose option `M` for the management server.

### Step 5 - Setup Cloudstack database
This step is just as easy as the last step. The database server (MySql) will be installed via the same `install.sh` script used in the last step.

    ./install.sh

This will once again try to update all packages. They should be up to date, so you should not have to wait long for this to finish. You will then be given the same prompt from your last run. This time choose option `D` to install the database.

During the install of the database server you will be asked for a password. This is the password for the user named `root` on the database. This is __not__ the same as the root user of the Ubuntu box. Pick a password that __does not__ include an `@` symbol. I at first used the password of `p@ssword1`. This caused so many headaches that its just not worth the workarounds. I went with a password of `password1`.

Once the database server is setup you need to create the databases used my the cloud management software.

    cloud-setup-database cloud:password1@localhost --deploy-as=root:password1

This command will create two databases in MySQL and fill them will your systems data.

### Step 6 - Finish Cloudstack management software setup
Finish the setup by running the management setup command line tool a second time. The command does a few things with iptables but it should all be transparent to you.

    cloud-setup-management

### Step 7 - Add System VM image
Add the system VM to the secondary storage and database.

    /usr/lib64/cloud/agent/scripts/storage/secondary/cloud-install-sys-tmplt -m /export/secondary -u http://download.cloud.com/templates/acton/acton-systemvm-02062012.vhd.bz2 -h xenserver -F

This will copy the system VM to the secondary storage location and setup database entries pointing to it. One of the gotchas I ran into was that the system VM image file must be access via HTTP. I first tried doing it as a local file since it is such a large file. I didn't want to download it from the Internet. Unfortanitly this does not work, so you must use a workaround. My desktop system is also a web server so I just put the system VM image there. You can also use the source URL instead of your local server. Make sure to use port 80 or it will not connect.

## Gotchas
* need more management ips than hosts so that support VMs can also have IPs
* Removing VMs does not clean up IP resources for a long time. Need to change the expunge settings.
