---
layout: post
date: 2010-03-17 21:55:09
comments: true
description: An overly complex fizz-buzz implementation
categories: C#, programming
keywords:
summary: An overly complex fizz-buzz implementation
title: FizzBuzz test in C#
permalink: /fizzbuzz_test_in_c_sharp
---

I've been looking at developer job related web sites to see what kinds of "things" are being used in interviews. There are a few programmer challenges that people are using to weed out the less capable developers. In particular the one called [Fizz-buzz test][1] is quite amazing to me. It isn't the simplicity of the challenge that gets me it is the fact that so many cannot write it during the interview. I would assume that any level of developer can easily complete this code. Although I keep seeing examples all over the web about how current *(2010)* job candidates cannot write it.

So, what the heck! Another example of how it can be done.

The challenge is to print all numbers from 1 to 100. When a number is divisible by 3 print "Fizz" instead. And when the number is divisible by 5 print "Buzz" instead. Lastly print "Fizz-Buzz" if the number is divisible by both 3 and 5.

**_Warning: This is overly complex to avoid being used in an interview_**

{% highlight c# %}
void Main()
{
    Console.WriteLine(
        Enumerable.Range(1, 100)
            .Aggregate(new StringBuilder(), (sb, i) => sb.AppendLine(fizzBuzz(i)))
            .ToString());
}

string fizzBuzz(int i)
{
    var isRule3 = i % 3 == 0;
    var isRule5 = i % 5 == 0;

    if(isRule3 && isRule5) return "Fizz-Buzz";
    if(isRule3) return "Fizz";
    if(isRule5) return "Buzz";
    return i.ToString();
}
{% endhighlight %}

[1]: http://imranontech.com/2007/01/24/using-fizzbuzz-to-find-developers-who-grok-coding
