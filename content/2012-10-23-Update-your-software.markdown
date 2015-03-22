---
layout: post
date: 2012-10-23
comments: true
description: Your periodic reminder to update your software
categories: macosx, unix
keywords: macosx, setup, unix
summary: Don't forget to update your software every once in a while
title: Update your software
url: /Update-your-software
---

Don't forget to update your software every once in a while. If your like me, then I'm sure your system if filled with out of date software.

Today while trying to get Github to update my code (constant network errors) I thought I would try updating [Homebrew][1]. Opps! Looks like I have been neglecting it for far to long.

Do this to make sure [Homebrew][1] package definitions is current.

    brew update

Once you have gotten the latest definitions do the following to get your software upgraded.

    brew upgrade <package name>

Major ones for me are

    brew upgrade git
    brew upgrade bash
    brew upgrade tmux
    brew upgrade ctags
    brew upgrade tree
    brew upgrade postgresql
    brew upgrade openssh

[1]: http://mxcl.github.com/homebrew/
