---
date: 2012-11-14
comments: true
description: How I learned to correctly access locals inside a partial view template.
categories:
  - rails
  - ruby
tags:
  - rails
  - ruby
  - partial
  - view
summary: Partial views get used in most web frameworks. In Rails and most other frameworks you can pass local variables to your partials. This is how I learned that in Rails these locals are instance methods and not instance variables.
title: Rails partial views and locals variables
url: /rails_partial_view_locals
---

Partial views are super common in just about all web frameworks; Rails is no different. I came to Rails from another web framework so I already knew the power of partial views. Naturally I've been using them everywhere I can to simplify and separate views. About the only thing I dislike about Rails partials is the double syntax for the locals variables. There is one syntax for a single model with the same name as the partial and another syntax for arbitrary named local variables. I tend to prefer consistency, so I mostly use the locals syntax.

## Personal story

This is where the bad part of coming to Rails from a different framework is. I just assumed that the local variables became instance variables in the partial view. In fact, I tried a partial with an instance variable and it worked as expected. Testing is believing in most cases, so I thought I had learned what I needed to know. Since then I've created dozens and dozens of partials, all using instance variables and everything has worked perfectly. That is, until I needed to create a partial view of the inside of a form with the form tag not inside the partial. I still needed the form's ID inside the partial so I could submit the form via JavaScript. Based on what I had learned I just passed it in as a local variable. And of course, I could not access the new local variable.

I tried everything I could think of to access the form's ID via the local variable. I even searched the instance variables (using #instance\_variables) of all the classes I could think of. I even looked back at partials I had created in the past. As far as I could tell, I was trying to access the variable correctly.

## Solution

It turns out the locals are accessed via instance accessor methods. This whole time I have been naming my controller's instance variables the same as my partial's local variables. This is why they always worked before. Only when I finally made a local variable that wasn't also an instance variable did I discover the difference.

## Summary

Drop the @ symbol in front of your variable while inside a partial view. Use them as instance methods and not as instance variables. I know my Google-fu couldn't find the answer. Hopefully yours will find this article before you pull all of your hair out.

Special thanks to my co-worker [Daniel Zajic][1] for pairing with me to solve the problem. He found the solution as soon as I told it to him. Clearly he had read the documentation I should have read earlier.

[1]: http://www.danielzajic.com/
