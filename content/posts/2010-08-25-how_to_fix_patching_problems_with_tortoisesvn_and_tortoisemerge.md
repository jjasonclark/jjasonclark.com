---
layout: post
date: 2010-08-25
comments: true
description: How to fix patching issues with TortoiseMerge
categories:
  - programming
tags:
  - merge
  - TortoiseSVN
summary: TortoiseMerge occasionally fails to work. I don't know the cause, but I did figure out how correct the issue so you can do another merge.
title: How to fix patching problems with TortoiseSVN and TortoiseMerge
url: /how_to_fix_patching_problems_with_tortoisesvn_and_tortoisemerge
---

Unfortunately a common occurrence when applying patches while using TortoiseSVN is that nothing gets patched even though the UI shows that patching has completed without errors. This happens when you do a “patch all” or individually go through each file. In addition, any modifications you make in the patched files don't get saved either.

I don't know the cause of this, but I do know a solution. The merging program used by default for TortoiseSVN is TortoiseMerge. It is installed with the main SVN package. You see it every time you do any merging from an update or doing a diff from a previous version of a file. The patching problem has something to do with the settings stored in the registry for TortoiseMerge. Deleting the whole hierarchy for this program will fix the issue. Of course you will need to restart the merge tool once you have deleted the registry keys in order for the changes to take effect.

![Tortoise Registry Keys](/assets/tortoisemerger_20100906_1640_thumb5.png)

To fix, follow these steps.

1. Delete registry hierarchy from HKCU\Software\TortoiseMerge
2. Restart patching program

Or run the following PowerShell command.

{{< highlight sh >}}
Remove-Item -path hkcu:software\TortoiseMerge –recurse
{{< /highlight >}}
