---
layout: post
date: 2010-07-17
comments: true
description: Using the ASP.Net membership provider in an application using SQLExpress database
categories: asp.net, programming, sql
keywords: programming, sql, asp.net
summary: Using the ASP.Net membership provider in an application using SQLExpress database
title: SQLExpress and ASP.Net membership provider
url: /sqlexpress_and_asp_net_membership_provider
---

One of my favorite activities is to create a new project. Just saying "file, new project" gets me thinking about all the possibilities. Lately I've been trying to work on my web development skills so I've been creating a lot of new web applications in Visual Studio. In many cases I also need to have these projects use the normal ASP.Net membership provider. This is where the common problem comes in.

_How do you setup ASP.Net membership with a SQLExpress database?_

There are some great blog posts already out there that try to explain what to do. Lance's blog post "[Using ASPNET\_RegSQL.exe with SQL Express databases in APP\_DATA][1]" seems to be the best one. Unfortunately his suggestion doesn't work well for me. It all boils down to the command line arguments being a little off.

To start with take a look at the [official command line reference][2] from Microsoft for the aspnet\_regsql.exe tool.

Popular link to how to article [http://weblogs.asp.net/lhunt/archive/2005/09/26/425966.aspx][3]

Another link with extra steps [http://scottonwriting.net/sowblog/posts/5480.aspx][4]

Link to official docs [http://msdn.microsoft.com/en-us/library/ms229862.aspx][5]

[1]: http://weblogs.asp.net/lhunt/archive/2005/09/26/425966.aspx
[2]: http://msdn.microsoft.com/en-us/library/ms229862.aspx
[3]: http://weblogs.asp.net/lhunt/archive/2005/09/26/425966.aspx
[4]: http://scottonwriting.net/sowblog/posts/5480.aspx
[5]: http://msdn.microsoft.com/en-us/library/ms229862.aspx
