---
date: 2010-06-24
comments: true
description: Learning Ruby via testing
categories:
  - programming
  - Ruby
tags:
  - ruby
  - learning
summary: Learning Ruby via testing. Trying to also learn the Rails server enivronment as well.
title: Learning Ruby
url: /learning_ruby
---

I thought I would give learning Ruby a try. The internet seems abuzz with talk about how amazing Ruby is, so it is at least worth a look. I also checked and my ISP does support Ruby on Rails apps.  It is a nice bonus to not have to pay any extra for hosting if I do actually make something.

I started by installing Ruby for windows via the installer from <http://rubyinstaller.org/>. I wanted to be able to use the Ruby Koans from <http://github.com/edgecase/ruby_koans> to learn from so I needed to do a little more setup. I also needed to install the gem for test-unit.

{{< highlight sh >}}
gem install test-unit --include-dependencies
{{< /highlight >}}

While I was inside an elevated command prompt I also installed Rails.

{{< highlight sh >}}
gem install rails --include-dependencies
{{< /highlight >}}
