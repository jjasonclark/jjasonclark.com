---
layout: post
date: 2014-10-13
comments: true
description: Consider using the tap method for code organization
categories:
  - ruby
  - development
tags:
  - ruby
  - development
summary: The tap method intruduces a new indention block. Consider using the tap method for code organization.
title: Consider using the tap method for code organization
url: /consider_using_the_tap_method_for_code_organization
---

I'm sure you have heard about the tap method. It has great uses for connecting to a chain of method calls; such as when using Enumerable. And the cool kids love to use it to avoid using a temp variable for return.

Another use is for code organization. The tap method addes a level of indention via it's block parameter. This block gives a visual section of code that can be useful when trying to understand what is being written.

{{< highlight ruby >}}
Something.new.tap do |something|
  # your code here
end
{{< /highlight >}}

For me, when I'm scanning through code, these visual indention changes really help me understand the code.
