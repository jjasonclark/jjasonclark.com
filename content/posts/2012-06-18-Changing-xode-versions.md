---
layout: post
date: 2012-06-18
comments: true
description: Changing Xcode versions
categories:
  - ruby
  - macosx
tags:
  - xcode
  - macosx
  - setup
  - ruby
summary: I recently needed to switch from developing for Rails 3.2.5 on Ruby 1.9.3 to working with Rails 2.3.5 on Ruby 1.8.7. The Rails version change wasn't that big of a deal, but the Ruby change was. Sometime between the release of 1.8.7 and 1.9.3 the supported GCC compiler changed. The newer compiler, the one I was on, had a breaking change making it not compatible with the older Ruby version. This meant that if I wanted to use Ruby 1.8.7 I was going to have to uninstall my current copy of Xcode and install an older version.
title: Changing Xcode versions
url: /Changing-xode-versions
---

I recently needed to switch from developing for Rails 3.2.5 on Ruby 1.9.3 to working with Rails 2.3.5 on Ruby 1.8.7. The Rails version change wasn't that big of a deal, but the Ruby change was. Sometime between the release of 1.8.7 and 1.9.3 the supported GCC compiler changed. The newer compiler, the one I was on, had a breaking change making it not compatible with the older Ruby version. This meant that if I wanted to use Ruby 1.8.7 I was going to have to uninstall my current copy of Xcode and install an older version.

## Uninstall Xcode

To uninstall you have two options depending on how you installed Xcode in the first place. Current versions of [Xcode are installed via the Mac App Store][1]. Older version were [installed via a downloaded package][6]. If you ever installed Xcode via the downloaded package then you have the uninstall script on your system. Otherwise you will have to do the normal manual steps. First try this command to run the uninstall script.

    sudo /Developer/Library/uninstall-devtools --mode=all

If this failed to run then you may have only installed via the [Mac App Store][3]. In which case you need to do the normal manual steps for removing an application from the Application's folder like any other Mac app.

## Installing Xcode 4.1

I am using some Ruby gems with native extensions. This allowed me to verify if I had the installation correct or not. Unfortunately I never could get the gems to build successfully under the normal download package for Xcode 4.1. Hoping to resolve the problem I created a question on Stack Overflow on ["How to install Xcode 4.1 for Ruby developmnt"][2]. No one was able to help me, but I was pointed to another GCC installer that did work. The [osx-gcc-installer][4] is a customized version of Xcode for command line development. The author has made a [package for Lion][5]. This worked perfectly for me. I haven't run into any issues using it for Ruby 1.8.7 development.

## Troubleshooting

If you have an error dialog saying that iTunes needs to be closed use the following commands to find and close the iTunesHelper app.

    ps -axo pid,comm | grep iTunesHelper | awk '{ print $1 }' | xargs kill -9

[1]: http://itunes.apple.com/us/app/xcode/id497799835?mt=12
[2]: http://stackoverflow.com/q/11006503/136584
[3]: http://www.apple.com/osx/apps/app-store.html
[4]: https://github.com/kennethreitz/osx-gcc-installer
[5]: https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.7-v2.pkg
[6]: https://developer.apple.com/downloads/
