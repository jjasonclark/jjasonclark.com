---
date: 2013-09-05
comments: true
description: Installing and setting up a basic configuration for Emacs.
categories:
  - programming
tags:
  - emacs
  - setup
summary: I'm a Vim user, but i'm not 100% sold on it. I keep wanting to find an even better editor. I've tried just about everything but nothing sticks. I'm starting a new book on Lisp programming so it is time to try Emacs again. May this time it will stick.
title: Trying out Emacs Again
url: /trying_out_emacs_again
---

I'm a Vim user, but I'm not 100% sold on it. I keep wanting to find an even better editor. I've tried just about everything, twice. Notepad++, Vim, Textmate, Coda, Visual Studio, Sublime Text, Notepad2, Scintilla, Cloud9, RubyMine, Eclipse, and many more.

## Land of Lisp

I've got 3 kids, so I don't get a lot of reading time. I'm finally getting a chance to read a book I picked up a while back, "[Land of Lisp](http://landoflisp.com/)". And this is prompting me to give Emacs another try. The last few times I've tried it I got tired of all the key combos I had to press to get _anything_ done. I'm hoping this time I can learn some of the Lisp for easier configuration.

## Setup

Not knowing the best way to get the latest version of Emacs I did what most do an searched Google. I found out that there are at least 2 easy ways to install Emacs. Either you download from the [EmacsForMacOSX](http://emacsformacosx.com/) site or you install via [Homebrew](http://brew.sh).

I did find an article that says I should [use homebrew instead of EmacsForMacOSX](http://struct.tumblr.com/post/46754394733/emacs-24-use-homebrew-instead-of-emacsformacosx).

I love the Homebrew system so I went that route.

    brew install emacs --cocoa --srgb

This installed version 24.3.1 of Emacs.

## Configuration

Next I needed a starter configuration. My childhood friend is also an Emacs user and posted [his config on Github](https://github.com/zev/emacs.d). So naturally I forked it. This was a while ago when I tried Emacs once before, so all I had to do was update it. There was some specific settings for his computer, so I have removed them from my copy.  Check it out at [jjasonclark/emacs.d](https://github.com/jjasonclark/emacs.d)
