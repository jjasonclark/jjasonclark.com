---
layout: post
date: 2013-05-09
comments: true
description: Converting from Vagrant 1.0 to 1.2 requires a change in Vagrantfile too
categories: programming, devops
tags: Vagrant, VM, virtualmachine, upgrade, chef, provision, hypervisor
summary: Vagrant is an amazing application for helping you manage your virtual machines. Renewed development effort by it's creators has brought us many new features. Unfortunately this forced a change in the semantics of the Vagrantfile. Here is how to do the most basic upgrades to remove the warning messages Vagrant creates from using the older file type.
title: Vagrant Going from old and busted, to new hotness
url: /vagrant_going_from_old_and_busted_to_new_hotness
---

[Vagrant][1] is an amazing application for helping you manage virtual machines. I feel like you are missing out if you haven't started using Vagrant yet. I highly recommend it. Vagrant helps out by keeping track of several things that you would normally do manually to maintain a VM. It does this via the `Vagrantfile` you place in your project's directory and check into source control. The file contains two basic parts; all of the meta data that the VM needs boot, and the steps used to provision the VM.

Vagrant has been out for a while now, so it has gone through several versions already. Lately there has been a renewed effort by the creators of Vagrant to add more features. In order to support these new features the semantics of the `Vagrantfile` had to change. In addition to the must change parts the Vagrant team has also done some changes to the existing parts that make it easier to interact with.

Converting to this new format is a fairly easy process to do. For the most part it just requires some renamed attributes or nesting inside of a block. These changes will remove any warning messages Vagrant is producing from your old `Vagrantfile`.

## Upgrading your Vagrant binaries

First things first, you will need to uninstall the old version of Vagrant. Most people installed Vagrant via the [gem][4]. As of this writing this will give you version 1.0.7. That version is before the new `Vagrantfile` format was created. You will need to download the binary version of from their [website][3], currently at version 1.2.2. As a person who works with many different versions of Ruby I highly recommend you don't go back to the gem version of Vagrant even if they update it to the latest version. The reason is that you will have to install the gem several times for each version of Ruby or remember to switch back to that version of Ruby in order to use the `vagrant` command. The binary install makes this so much easier because you don't have to do any of those workarounds.

## Upgrade your Vagrantfiles

Once you have the latest version install open up your `Vagrantfile` and change a few values. Replace your main setup block to the following. This will give you access to all of the new attribute names and features.

{{< highlight ruby >}}
Vagrant.configure('2') do |config|
end
{{< /highlight >}}

From here you will need to change a few standard meta data settings.

* `host_name` is now `hostname`
* `sync_folder` is now `synced_folder` and it's first 2 parameters have swapped places
* `forward_port` is now an option off of `network` with named parameters. Go from `config.vm.forward_port 3000, 3000` to `config.vm.network :forwarded_port, :guest => 3000, :host => 3000`
* `customize` is now nested under `provider`. Go from `config.vm.customize ['modifyvm', :id, '--cpus', 2]` to `config.vm.provider :virtualbox { |box| box.customize ['modifyvm', :id, '--cpus', 2] }`
* `:hostonly` networking is now `:private_network`

Don't forget that there are a lot of new options. Check out the [Vagrant documentation][2] for more details on the items listed here and all the new options.

[1]: http://www.vagrantup.com/ "Vagrant"
[2]: http://docs.vagrantup.com/v2/ "Vagrant documentation"
[3]: http://downloads.vagrantup.com/ "Vagrant downloads"
[4]: http://rubygems.org/gems/vagrant "Vagrant gem on RubyGems"
