---
layout: post
date: 2009-12-06
comments: true
description: Simulating SQL's in operator in Linq
categories: C#, Linq, programming
tags: C#, Linq
summary: SQL has a range variable search keyword called 'in' that is a not exposed by default in Linq.
title: Replicating SQL's in operator in Linq
url: /replicating_sql_in_operator_in_linq
---

One of the common programming problems is sorting a complex object on a list of criteria. For example, given the following class.

{% highlight c# %}
public class Car
{
    public int ModelNumber { get; set; }
}
{% endhighlight %}

Imagine you wanted to pick out all Cars in your data model that had Model Numbers between 2 and 4? In Linq you would normally do something like this.

{% highlight c# %}
var wantedModeles = new int[] { 2, 3, 4};
var sortedCars = Cars.Where(car => wantedModeles.Contains(car.ModelNumber));
{% endhighlight %}

This of course works but it doesn't look very elegant at all. In fact I much prefer the SQL syntax version of this kind of query; using the in operator. So I've been thinking about away to make this work a little better. Well I've finally come up with a solution that I like.  Take a look at this example.

{% highlight c# %}
var wantedModeles = new int[] { 2, 3, 4};

var sortedCars2 =
    from car in Cars
    join model in wantedModeles on car.ModelNumber equals model
    select car;
{% endhighlight %}

In this case I create use a join operation to sort the wanted sub-list of items. The join operation sorts out all of the items wanted based on the joined properties. I like this syntax a lot more because I can combine it with where clauses that would normally be if/then/else statements after the initial query.
