---
layout: post
date: 2010-01-17
comments: true
description: Converting a Sourceforge project to Github
categories:
  - git
tags:
  - autorealm
  - git
  - github
  - programming
  - sourceforge
summary: I was looking for a reason to play with Git more so I thought a good exercise would be to convert an open source project not already using Git. At the same time I put it on Github for easy access.
title: Converting a Sourceforge project to Github
url: /converting_a_sourceforge_project_to_github
---

I was looking for a reason to play with [Git][1] more, so what better a way than to find an open source project that isn't already on [Github](http://github.com) and convert it. I wanted to try out some of the basic commands but didn't have a good source to work with. Using real files feels better to me than using a bunch of dummy files so I've pulled over the files from the [Autorealm](http://sourceforge.net/projects/autorealm) project.

What I needed to do was get the source for Autorealm, clean up the directories, and setup the initial Git repository. Autorealm is hosted on [Sourceforge](http://sourceforge.net) using the Mercurial version control system. This was my first exposeure to the system so it was nice to discover it was easy to clone the repository.

I converted the source by first downloading the [Mercurial windows client](http://mercurial.selenic.com/downloads) and used the following command.

{{< highlight sh >}}
hg clone http://autorealm.hg.sourceforge.net:8000/hgroot/autorealm/autorealm
{{< /highlight >}}

Autorealm is going through a rewrite from Pascal to Python. The original Pascal repository uses the following command.

{{< highlight sh >}}
hg clone http://autorealm.hg.sourceforge.net:8000/hgroot/autorealm/autorealm_delphi
{{< /highlight >}}

![Screenshot of SourceForge project download](/assets/autorealm_2010_01_17.png)

This downloaded the two repositories to my local machine. In total it took about 10 minutes to get both. From here I cleaned up the directories to remove the old source control files. The directory structure is only a single level deep so it didn't take long to do it by hand. When I started the two repositories together were 441 MBs; after the conversion I had only 146 MBs.

Once I had the clean directories I did the following Git commands to create the first commit.

{{< highlight sh >}}
git init
git add .
git commit -m "Initial copy from Sourceforge"
{{< /highlight >}}

On Github I created the repositories where I would push to. Then pushed them to Github.

![Screenshot of Github dashboard](/assets/autorealm_repository_2010_01_175.png)

{{< highlight sh >}}
git remote add github git@github.com:jjasonclark/Autorealm.git
git push github master

git remote add github git@github.com:jjasonclark/Autorealm_delphi.git
git push github master
{{< /highlight >}}

And now I have [Autorealm](http://github.com/jjasonclark/Autorealm) and [Autorealm\_delphi](http://github.com/jjasonclark/Autorealm_delphi).

[1]: http://en.wikipedia.org/wiki/Git_(software)
