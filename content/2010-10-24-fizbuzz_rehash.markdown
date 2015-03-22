---
layout: post
date: 2010-10-24 20:01:30
comments: true
description: An overly complex fizz-buzz implementation
categories: programming, interview
keywords:
summary: An implementation of fizz-buzz that is overly complex. Something you want to avoid in an interview.
title: Fizz-buzz rehash
permalink: /fizbuzz_rehash
---

While moving my blog content from site to site my post on Fizz-buzz caught my eye again. I thought I would post another implementation that was even more complex (read _don't use in your interview_)

This one uses the iterator pattern and the null coalescing operator for added complexity.

{% highlight c# %}
void Main()
{
    Console.WriteLine(string.Join(", ", FizzBuzz().Take(100).ToArray()));
}

string[,] fbLogic = new string[2, 2]
{
    {"Fizz-Buzz", "Fizz" },
    {"Buzz", null }
};

IEnumerable FizzBuzz()
{
    for (int i = 1; true; ++i)
    {
        yield return fbLogic[i % 3 == 0 ? 0 : 1, i % 5 == 0 ? 0 : 1] ?? i.ToString();
    }
}
{% endhighlight %}
