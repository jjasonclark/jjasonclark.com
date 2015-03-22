---
layout: post
date: 2008-12-19 15:23:47
comments: true
description: Gave Silverlight 2.0 a try for the first time
categories: programming Silverlight
tags: Silverlight programming C#
summary: I started playing with Silverlight 2.0. I learned a lot about the data modeling classes and what is supported. Going to have to spend much more time with Silverlight if I'm going to make anything useful
title: Started working with Silverlight
permalink: /started_working_with_silverlight
---

Thanks to the last few days being snow days I've gotten some work done on the programming front.  I've been playing with Silverlight 2.0.  I installed the [SDK][1] and have started working on a Solitaire program.  I figured that a program with no external input would be nice to start with.  Although for my next project I would like to try connecting to a REST service.

First thing I did was think about a data model that would work for the game.  As you can imagine it only took 1 table with a few other enum like tables.  I though that since Solitaire is so easy I would code the game logic first and then spend the rest of the time playing with the UI.  Really there are only a few moves that you can make.  And rules for checking if you have won or can't move any more are really easy.  I thought it would only take me about an hour to finish it all.

Well it turns out that Silverlight 2.0 doesn't support ADO.Net.  No DataSets or DataTables.  As far as I can tell they (Microsoft) want you to use only the Entity framework.  Or baring that, your own custom objects.  Since I'm not using a database that left me with custom objects.  I made a game board object with several ObserveableCollections for each of the card stacks.  Almost no coding at all.  No need to focus on what Silverlight doesn't have.  So I moved on to the UI.

I wanted to start by playing with the data binding.  I knew that if I made my card objects with a ToString method that a ListBox would show them.  I created a Grid with 7 columns and 2 rows.  Each cell has a ListBox to show the cards in that stack.  Basically the standard layout.  I then tried 2 different ways to databind the ListBoxes to the collections in the game board object.

First way was to make a DependencyProperty on the page class.  DependencyProperties have at least 1 major draw back in my opinion.  The bindings don't work by default.  You have to wait for a Loaded event to set the binding source (or context) otherwise the property isn't set by the time the XAML is parsed.  I played around with this for a while and that was the only down side.  And it isn't that big of a deal to deal with.  Subscribing to an event is very easy.

This second way I think is much better.  I added the game board as a resource for the page and then set the binding source on the Grid to it.  This worked without having to subscribe to any events.  I also found out that accessing the object in resources is done by simply accessing the Resources property off of the page object.  this.Resources[“GameBoard”] as GameBoard.  I made a non-DependencyProperty who's get method returned the GameBoard.

Using resources seems to feel better to me.  More akin to the MVC pattern.  The page only has a resource that is set by the XAML.  You never have to jump into code for it.  I haven't played with Blend yet, but I would guess that using a resource allows for some default data while editing in design mode.

Anyhow, I need to work with my ISP to see if I can get the app hosted.  I've got plenty more to work on before it's done.  Although it is just about playable now.  I don't have the cards being drawn though.  They are just displaying as single text lines in the ListBoxes.  Still it would be nice to see it out on the Internet.

[1]: http://go.microsoft.com/fwlink/?LinkId=129043 "Microsoft® Silverlight™ Tools for Visual Studio 2008 SP1"
