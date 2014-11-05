---
layout: post
date: 2012-11-26
comments: true
description: How to search Git using Vim to display more context for the output
categories: vim, git, tips
keywords: vim, git, plug-ins
summary: Searching Git repositories is very simple using the Fugitive and Unimpaired plug-ins. They allow you to jump to each file and line in the result set with default keybindings.
title: Searching a Git repository using
permalink: /searching_git_with_vim
---

I frequently need to search source code repositories. I normally cannot get through a workday without doing it at least once. Git makes this super simple with it's `grep` command. Only issue I have with it is the output. You get the filename and the line with the matched string. Good for searches with lots of results, but not so useful for things you want to see with lots of context.

A common trick is to search for something with very low number of results and then load the files into Vim to get context. Something like the ID of an HTML element or the name of a method. You can even modify the output of the search to only print the filenames with the `-i` argument to make loading into Vim easier. Although there is an even easier way. Use 2 must have plug-ins for Vim; [Fugitive][] and [Unimpaired][]

## How to use the plug-ins

[Fugitive][] provides the `:Ggrep` command. It works just like the normal Git `grep` command. The key difference is that it loads the results into the quickfix list. This is where the [Unimpaired][] plug-in comes into play. It provides keybindings for navigating the quickfix listings. `]q` advances in the list and `[q` goes back to the previous item.

If you need to jump around or see the whole output use the `:copen` command. From this window you can use the `j` and `k` keys to move around the list and `Ctrl+w enter` key sequence to open the file under the cursor.

You can use all the normal arguments that the git-grep command takes. The ones I use the most are fixed strings with `-F` and extended regex with `-E`.  These plug-ins have numerous other features. I highly encourage you to read the [man page for Fugitive][1] and the [man page for Unimpaired][2].

[1]: https://github.com/tpope/vim-fugitive/blob/master/doc/fugitive.txt
[2]: https://github.com/tpope/vim-unimpaired/blob/master/doc/unimpaired.txt
[Fugitive]: https://github.com/tpope/vim-fugitive
[Unimpaired]: https://github.com/tpope/vim-unimpaired
