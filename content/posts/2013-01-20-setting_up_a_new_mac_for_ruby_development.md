---
layout: post
date: 2013-01-20
comments: true
description: Setting up a new Mac for Ruby development
categories:
  - programming
  - setup
tags:
  - setup
  - tips
  - mac
  - ruby
  - development
summary: I recently switched how I was using one of my laptops. I wanted to make a clean break from what it was doing before, so I erased the hard drive and started from scratch. I've done this a few times already and I always seem to forget a step. So this time I wrote down the steps so I could repeat them later. These are the steps I take to setup a Mac for Ruby development using Vim as the editor and MySql as the database. Of course there are a few other programs that I use while developing. The whole group, in my opinion, make for the most basic setup.
title: Setting up a new Mac for Ruby development
url: /setting_up_a_new_mac_for_ruby_development
---

I recently switched how I was using one of my laptops. I wanted to make a clean break from what it was doing before, so I erased the hard drive and started from scratch. I've done this a few times already and I always seem to forget a step. So this time I wrote down the steps so I could repeat them later. These are the steps I take to setup a Mac for Ruby development using Vim as the editor and MySql as the database. Of course there are a few other programs that I use while developing. The whole group, in my opinion, make for the most basic setup.

## Install from App store

There are a few apps that are managed through the App store. Search for, and install the following apps. Only Xcode is required, the others help in the development process.

* Xcode
* ClamXav
* Evernote
* Skitch
* JollysFastVNC
* Twitter

Once these have installed launch `ClamXav` in order to turn on virus definitions file downloads. Select a time that works for you.

![ClamXav preferences](/assets/clamxav_preferencest_2013_01_21.png)

## Install from web

The following don't have any handy install scripts. You will have to visit each one's website and download the installer package. All are optional, so you can put these off until later if desired.

* [Chrome](https://www.google.com/intl/en/chrome/browser/)
* [Evernote web clipper chrome plugin](https://chrome.google.com/webstore/detail/evernote-web/lbfehkoinhhcknnbdgnnmjhiladcgbol)
* [LastPass chrome plugin](https://chrome.google.com/webstore/detail/one-last-pass-password-ma/hlcjfeemfanamjbekpmdhcefejlgpnke)
* [Iterm2](http://www.iterm2.com)
* [SequalPro](http://www.sequelpro.com/)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Truecrypt](http://www.truecrypt.org/)
* [Dropbox](http://www.dropbox.com/)
* [Skype](http://www.skype.com)
* [Sublime Text 2](http://www.sublimetext.com/2)
* [Bittorent](http://www.bittorrent.com/)

## Setup MySql

MySql is the defacto database for development mode. And it is a tad hard to install.

####Download the install files

Download the `DMG` file for the 64-bit version. [MySql download page](http://dev.mysql.com/downloads/mysql)
![MySql DMG file](/assets/mysql_dmg.png)

####Install main package file

This is a basic Mac package file. Just follow along the prompts.

####Install perference panel settings app

Drag and drop the preference panel icon onto your system preference window. You should get a dialog like the one below. Install for everyone.
![Prefence panel install dialog](/assets/mysql_prefpane_install.png)

####Install statup items app

Another basic Mac package file. Just follow along the prompts just like before.

####Start the server

Launch the install MySql perference panel. Once open press the start button.
![blah](/assets/mysql_preferences.png)

####Complete setup

Run the following commands in a terminal window. They will complete the setup of the MySql service, configure for medium sized profile, and fix a linking bug with mysql2 gem.

    /usr/local/mysql/bin/mysql_secure_installation
    sudo cp /usr/local/mysql/support-files/my-medium.cnf /etc/my.cnf
    ln -s /usr/local/mysql/lib/libmysqlclient.18.dylib /usr/lib/libmysqlclient.18.dylib
    sudo /Library/StartupItems/MySQLCOM/MySQLCOM restart

####Add `/usr/local/mysql/bin` to `$PATH`

I like to include the following in my `.profile` file to add the MySql bin path to my `$PATH` setting.

    function addPath
    {
        echo $PATH | /usr/bin/grep -q -s $1
        if [ $? -eq 1 ] ; then
            export PATH=$1:$PATH
        fi
    }

addPath "/usr/local/mysql/bin"


## Command line compiler and build system

Most applications install as source that you will need to build yourself. Ruby also needs the compiler for C extensions. You use *XCode* to install these tools. First, launch *XCode* and open the preferences panel. Click on the "Downloads" tab and press the install button for the "Command Line Tools".

![Download preferences](/assets/xcode_commandline.png)

## Homebrew package manager

[Homebrew][2] is the package manager needed to install all the rest of the software. I find it indispensable. Copy and paste this command into a terminal window.

    ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"

Finish setup of [Homebrew][2] with the following commands.

    sudo vim -c '/^\/usr\/local\/bin$/m0' -cwq /etc/paths
    mkdir ~/Applications
    brew doctor

Once you have completed the set install the following packages by entering each of the following commands.

    brew install macvim --override-system-vim
    brew install git
    brew install ctags
    brew install par
    brew install tmux
    brew install reattach-to-user-namespace
    brew install gpg
    brew install ack
    brew install tree
    brew install ssh-copy-id
    brew install wget

After all installs run the following command to add symlinks to those apps that need it

    brew linkapps

## RVM for Ruby version management

This is the first place to go to install ruby virtual machines. The following shell command will download the latest version of [RVM][1]. Copy and paste this command into a terminal window.

    curl -L https://get.rvm.io | bash -s stable --ruby

You will have to add the load call for the [RVM][1] functions to your shell. If you are going to copy the `.profile` file from below then you will have it as the first line.

## Profile setup

Create a `.profile`. The following is a good starting point. I highly encourage customizing this file and saving it to move from computer to computer. The following will add the currently installed shell completion files. Along with a prompt to show the current ruby version and git branch.

    #Shell completion scripts
    function include
    {
        [[ -s $1 ]] && . $1
    }

    include "$HOME/.rvm/scripts/rvm"
    include `brew --prefix git`/etc/bash_completion.d/git-completion.bash
    include `brew --prefix git`/etc/bash_completion.d/git-prompt.sh
    include `brew --prefix tmux`/etc/bash_completion.d/tmux
    include "$HOME/.rvm/contrib/ps1_functions"
    include ~/.nesta-completion.sh

    export EDITOR=`which vim`

    function prompt
    {
        local OFF="\[\033[m\]"

        # regular colors
        local BLACK="\[\033[0;30m\]"
        local RED="\[\033[0;31m\]"
        local GREEN="\[\033[0;32m\]"
        local YELLOW="\[\033[0;33m\]"
        local BLUE="\[\033[0;34m\]"
        local MAGENTA="\[\033[0;35m\]"
        local CYAN="\[\033[0;36m\]"
        local WHITE="\[\033[0;37m\]"

        # empahsized (bolded) colors
        local EBLACK="\[\033[1;30m\]"
        local ERED="\[\033[1;31m\]"
        local EGREEN="\[\033[1;32m\]"
        local EYELLOW="\[\033[1;33m\]"
        local EBLUE="\[\033[1;34m\]"
        local EMAGENTA="\[\033[1;35m\]"
        local ECYAN="\[\033[1;36m\]"
        local EWHITE="\[\033[1;37m\]"

        # background colors
        local BGK="\[\033[40m\]"
        local BGR="\[\033[41m\]"
        local BGG="\[\033[42m\]"
        local BGY="\[\033[43m\]"
        local BGB="\[\033[44m\]"
        local BGM="\[\033[45m\]"
        local BGC="\[\033[46m\]"
        local BGW="\[\033[47m\]"
        export PS1="${EGREEN}\u${WHITE}@${BLUE}\h ${MAGENTA}\w ${GREEN}"'$(~/.rvm/bin/rvm-prompt '"i v"')'" ${RED}"'$(__git_ps1 "(%s)")'"${OFF}> "
    }
    prompt

    # Shortcuts
    alias g=git
    function be()
    {
        bundle exec $@
    }

    function sublime()
    {
        open -a 'Sublime Text 2' $@
    }

## Post install steps

After it is all installed there are a few left over steps. Finish them if you like since they are optional.

* Change default profile of *Iterm2* to use "xterm-256color" terminal type
* Create new gpg secret key or copy old one (RSA type is fine)
* Create new ssh key
* Add ssh key to github.com
* Setup .gitconfig and .gitignore
* [Setup for pair programing using SSH and Tmux](Remote-Pairing-with-SSH-and-Tmux-on-a-Mac)

[1]: https://rvm.io/ "Ruby Version Manager"
[2]: http://mxcl.github.com/homebrew/ "Homebrew"
