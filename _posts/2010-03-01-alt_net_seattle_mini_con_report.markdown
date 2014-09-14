---
layout: post
date: 2010-03-01 15:17:15
comments: true
description: Report on Alt.Net Seattle's first conference
categories: programming
keywords: conference, .Net
summary: I went to my first Alt.Net Seattle meeting on Saturday. It was a mini conference created so the Microsoft MVPs could meet while they were already in Seattle for the MVP global summit. I have to say I really liked it.
title: Alt.Net Seattle mini con report
permalink: /alt_net_seattle_mini_con_report
---

# Alt.Net Seattle mini con report

I went to my first [Alt.Net Seattle](http://www.altnetseattle.org) meeting on Saturday. It was a mini conference created so the Microsoft MVPs could meet while they were already in Seattle for the [MVP global summit](http://www.mvpsummit2010.com). I have to say I really liked it.

It started at 10 AM, but I wasn't able to get there until a bit before noon. I was out doing the Saturday morning breakfast thing with the grandparents so they could spend some time with Zachary. Well worth the time, although I missed the best sessions of the day. At 10 AM they started with a session on MVC and another on CodeRush. Completely bummed I didn't get to go to either one of those. Although there was a good selection of topics left to go to after the noon lunch break.

The conference was done in an open session style. In total there were 5 rooms used for 1 hour sessions. A schedule of events was on the main room's white board. In total I believe there were 15 sessions to choose from. I picked sessions on writing maintainable code, test theories, working on open source projects, and an introduction to the Cucumber test style.

The maintainable code session was a group discussion on coding standards for formatting. Some of the items were useful but over all the group agreed that it didn't really matter much as long as you were consistent across multiple files.

Testing theories was a talk by [Charlie Poole](http://www.charliepoole.org) of NUnit fame. The topic was focused on how theories could be used in NUnit. Currently he has some preliminary support for the idea with more coming soon based on how the talk went. He wanted to explain this new concept and get feedback on how it would be useful. To me, the idea looked a lot like directed fuzz testing. The idea is that random input can be used to test for conditions you have not already thought of. Although in this case instead of making an output format via the fuzz tool's modeling language you use unit tests with attributes. Also there are input limiter predicate functions inside of the test to skip the random input that the method cannot use.  Hard concept to think about now since it is so new. Although I can see that this could go somewhere. If nothing else you can use it to create a pre-generated group of test objects that are fed to all of the test cases based on their predicate functions. I'm interested in seeing where he takes this testing technique.

The testing sessions was followed by an open source discussion lead by [Louis DeJardin](http://whereslou.com). The topic was how to get more people to participate. The most basic take away was that any contribution is a great start for anyone to get involved and their effort should be rewarded. Additionally there was some good ideas about how to get that first involvement from a new developer. My favorite was to leave easy bugs to fix, or empty unit test stubs to be filled in. Both of these are very low hanging fruit for any developer to use as a starting point.

Lastly the conference, for me, ended with a session on Cucumber style tests. [Glenn Block](http://blogs.msdn.com/gblock) showed off how tests can be written in plain English. The tests seemed OK, but the way to support these tests seemed extremely fragile. Regular expressions are used to mark what methods are called based on the English text. His main reason for supporting this style of testing is that there doesn't have to be a translation from the paper version of requirements created with the customer. Although I would argue that creating the Regex style methods is a translation step.
