---
layout: post
date: 2010-09-01 17:18:25
comments: true
description: More efficient queries using the Any() method vs Count()
categories: programming
tags: .Net sql
summary: The Any() extension method helps make much more efficient SQL queries. Use it and love it!
title: Any() is your friend
permalink: /any_is_your_friend
---

I often see developers writing code that is checking for the existence of something using the Count() method. This should be avoided in favor of the [Any()](http://msdn.microsoft.com/en-us/library/system.linq.enumerable.any.aspx) method and it's overloads.

Given this SQL layout

{% highlight sql %}
USE [Test]
GO
CREATE TABLE [dbo].[HostGroup](
    [HostGroupIndex] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](255) NOT NULL
    CONSTRAINT [PK_HostGroup] PRIMARY KEY CLUSTERED ( [HostGroupIndex] ASC ) ON [PRIMARY],
    CONSTRAINT [uq_HostGroup_Name] UNIQUE NONCLUSTERED ( [Name] ASC ) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Host](
    [HostIndex] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](255) NOT NULL,
    [FKHostGroupIndex] [int] NULL
    CONSTRAINT [PK_Host] PRIMARY KEY CLUSTERED ( [HostIndex] ASC ) ON [PRIMARY],
    CONSTRAINT [uq_Host_Name] UNIQUE NONCLUSTERED ( [Name] ASC ) ON [PRIMARY],
    CONSTRAINT [fk_Host_HostGroup] FOREIGN KEY([FKHostGroupIndex]) REFERENCES [dbo].[HostGroup] ([HostGroupIndex])
) ON [PRIMARY]
GO
{% endhighlight %}

A query for the names of HostGroups with hosts named 'JCLARK-DESK'.

{% highlight c# %}
HostGroup.Where(hg=>hg.Host.Any(h=>h.Name == "JCLARK-DESK")).Select(hg=>hg.Name)
{% endhighlight %}

Translates to SQL as

{% highlight sql %}
-- Region Parameters
DECLARE @p0 NVarChar(11) = 'JCLARK-DESK'
-- EndRegion
SELECT [t0].[Name]
FROM [HostGroup] AS [t0]
WHERE EXISTS(
    SELECT NULL AS [EMPTY]
    FROM [Host] AS [t1]
    WHERE ([t1].[Name] = @p0) AND ([t1].[FKHostGroupIndex] = [t0].[HostGroupIndex])
)
{% endhighlight %}

The embedded query is much more efficient than the same code written using the Count() method instead.

{% highlight c# %}
HostGroup.Where(hg=>hg.Host.Count(h=>h.Name == "JCLARK-DESK") != 0).Select(hg=>hg.Name)
{% endhighlight %}

Translates to SQL as

{% highlight sql %}
-- Region Parameters
DECLARE @p0 NVarChar(11) = 'JCLARK-DESK'
DECLARE @p1 Int = 0
-- EndRegion
SELECT [t0].[Name]
FROM [HostGroup] AS [t0]
WHERE (
    SELECT COUNT(*)
    FROM [Host] AS [t1]
    WHERE ([t1].[Name] = @p0) AND ([t1].[FKHostGroupIndex] = [t0].[HostGroupIndex])
) > @p1
{% endhighlight %}
