---
layout: post
date: 2014-12-13
comments: true
categories: golang, development, commandline
tags: golang, development
summary: How to wait for the interrupt signal using Golang and command line programs
title: Waiting for Ctrl+C in Golang
url: /waiting_for_ctrl_c_in_golang
---

Waiting for Ctrl+C in Golang

Creating services can sometimes mean needing to wait on the command line for the user to end the process. This is normally done via signals by pressing Control+C. In Go this is fairly easy to accomplish. The following code should be enough to get you started putting it into your applications.

In Go’s implementation of signals the signals are delivered via a channel. Create an `os.Signal` channel with at least 1 buffered space. The signals come in fast so you don’t want miss them. Let the system know you want `os.Interrupt` signals to go to the channel you created. Then just wait for the signal to come it via a go function.

{{< highlight go >}}
var signal_channel chan os.Signal
signal_channel = make(chan os.Signal, 1)
signal.Notify(signal_channel, os.Interrupt)
go func() {
    <-signal_channel
}()
{{< /highlight >}}

Now that you can respond to when the signal is triggered you need to add in the code to wait for this to happen. `sync.WaitGroup` fits the bill. Create one, `Add` a delta to it, and call `Wait`. This will block the current execution path waiting for a `Done` call on the created `WaitGroup`.

Add this into the previous snippet to create the `WaitGroup` before listening for the signal. And `Wait` for the `WaitGroup` at the end.  And use the retrieval of the signal to call `Done`.

{{< highlight go >}}
var end_waiter sync.WaitGroup
end_waiter.Add(1)
var signal_channel chan os.Signal
signal_channel = make(chan os.Signal, 1)
signal.Notify(signal_channel, os.Interrupt)
go func() {
    <-signal_channel
    end_waiter.Done()
}()
end_waiter.Wait()
{{< /highlight >}}

Putting it all together into a short package to show it off.  Here is the full code.

{{< highlight go >}}
package main

import (
    "fmt"
    "os"
    "os/signal"
    "sync"
)

func WaitForCtrlC() {
    var end_waiter sync.WaitGroup
    end_waiter.Add(1)
    var signal_channel chan os.Signal
    signal_channel = make(chan os.Signal, 1)
    signal.Notify(signal_channel, os.Interrupt)
    go func() {
        <-signal_channel
        end_waiter.Done()
    }()
    end_waiter.Wait()
}

func main() {
    fmt.Printf("Press Ctrl+C to end\n")
    WaitForCtrlC()
    fmt.Printf("\n")
}
{{< /highlight >}}
