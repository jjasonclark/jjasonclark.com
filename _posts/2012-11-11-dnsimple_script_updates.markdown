---
layout: post
date: 2012-11-11
comments: true
description: Using scripts to update DNSimple for home IPs
categories: Unix, DNS, tmux, ssh, bash
keywords: router, setup, Unix, ssh, API, bash, DNSimple
summary: The API at DNSimple allows easy updates. You can use them to add a subdomain to point to your home router. I make extensive use of this for remote pair programming.
title: Update DNSimple to point to your home router
permalink: /dnsimple_script_updates
---

# Update DNSimple to point to your home router

I use the DNS provider [DNSimple][1] ([referral link][3]). I am extremely happy with the service. They provide an JSON API to update their records dynamically. I use this API along with some Unix scripts to make sure I have an up to date subdomain that points to my home router. I use this almost every day to do remote pair programming. Additionally I use it to allow VPN access to my home network when I'm out and about at meetups and such. Honestly, I love it so much I should have blogged about it months ago. Because I had this setup I was able to get pair programming setup with virtually no effort.

I combine a service to tell me my requesting IP address with a bash script to create a JSON packet for the DNSimple API. My IP address service of choice is [ICanHazIP.com][2]. I like this one because of the super simple response format. One of these days I'll create my own service, I just need the time to do it. <small>(Unless you want to submit one in the comments. I would love you if you did.)<small>

## Discovering your external IP address
Simple use curl to make a call to [http://ICanHazIP.com][2] and the output is the external IP address of your network. `curl http://icanhazip.com`. In the script I use the silent option to not show the progress bar.

## Updating a DNS A record for your home router
Then I use [DNSimple's record API][4] to update the subdomain's A record to point to this IP address. The API accepts the following JSON packet as a post HTTP action.

{% highlight json %}
{
    "record": {
        "content": "<ip address>"
    }
}
{% endhighlight %}

## Final script
This all comes together in the following bash shell script. I call it `dnsimple.sh`.
 
{% highlight sh %}
#!/bin/bash

LOGIN="<enter yours here>"
PASSWORD="<enter yours here>"
DOMAIN_ID="<enter yours here>"
RECORD_ID="<enter yours here>"

echo "Getting current external IP"
IP="`curl -s http://icanhazip.com/`"
echo "Current external IP is $IP"

echo "Updating external record to $IP"
curl -H "Accept: application/json" \\
    --basic -u "$LOGIN:$PASSWORD" \\
    -H "Content-Type: application/json" \\
    -i -X PUT https://DNSimple.com/domains/$DOMAIN_ID/records/$RECORD_ID.json \\
    -d {\\"record\\":{\\"content\\":\\"$IP\\"}} -s > /dev/null

echo "Set record"
{% endhighlight %}

## Update hourly
I want this to run every so often to make sure the IP is correct just in case my internet provider changes my external IP address. So far this has never happened, but it's good to be ready for it when it does. I do this update by running the `dnsimple.sh` script every hour via a cron task. These are set in my `/etc/crontab` file.

{% highlight sh %}
# m h  dom mon dow   command
@hourly /root/bin/setDNSimple.sh > /dev/null 2>&1
{% endhighlight %}

## Finished
Thats it! Its all setup. Every hour my external IP will have a functioning DNS record for others to point to. SSHing into my server is as simple as `ssh subdomain.mydoamin.com`. For added security move your SSH port to a different number. Security by obscurity, but better than nothing.

[1]: http://dnsimple.com
[2]: http://icanhazip.com/
[3]: https://dnsimple.com/r/65fab1b1ffee66 "DNSimple referal link"
[4]: http://developer.dnsimple.com/domains/records/ "Record API reference"
