---
layout: post
date: 2013-08-29
comments: true
description: Getting settings to work in a Sinatra app that includes other Sinatra apps can be done a lot easier than you think using the Rack::Config middleware.
categories: programming
tags: ruby, rack, middleware, settings
summary: Getting settings to work in a Sinatra app that includes other Sinatra apps can be done a lot easier than you think using the Rack::Config middleware. I show how I created a Sinatra app with several nested Sinatra apps. And how I solved the issue with using a shared settings value from outer apps to the inner apps.
title: Sinatra Settings for Nested Apps
url: /sinatra_settings_for_nested_apps
---

I finally got a chance to do some work with [Sinatra][]. Something more than the typical `Hello, World!` app. I needed a UI on top of a restful web API. The docs are written using `curl` calls into their service, with JSON response payloads. Easy enough to deal with, but I wanted something a bit more robust. Thus I created [Cardspring_browse][].

The app is little more than HTML over a JSON API. Which isn't to bad since most apps are just HTML over SQL. I needed to handle to many URLs to have it all in a single file so I split it up into several apps. I then used an outer app to include all the inner apps.

{{< highlight ruby >}}
class Inner < Sinatra::Base
  get "/inner" do
    # ...
  end
end

class Outer < Sinatra::Base
  use Inner

  get "/" do
    # ...
  end
end
{{< /highlight >}}

Easy enough until it came time to share some configuration settings.  Each split up file seemed to get it's own copy of the `settings`. This meant that the outer app's settings didn't apply. I tried all kinds of things, but nothing worked. I resorted to asking a [question on Stack Overflow][2].

The answer there was acceptable, but not the ideal. I thought if I read the source code I might be able to figure something better out. It turns out the source for [Sinatra][3] and [Rack][] are very readable. Both are very tiny too. After reading the answer was clear. The pattern used throughout many Rack apps is to set values in the `env` parameter hash that is passed to the `call` method. Typically you use a string with the name of your app and the name of the value separated by a `.` (period).

The Cardspring_browse app uses it [here][1]. This code uses the Rack middleware [Rack::Config][4] to achieve the result.

{{< highlight ruby >}}
use Rack::Config do |env|
  env["my_app.my_property"] = "custom value"
end
{{< /highlight >}}

The full code for the outer application is the following. From the looks of the code I don't yet know the best practice for creating larger Sinatra apps. I still need to figure out the best way to split up the URLs into different files and still create a maintainable codebase. I think this style might be abusing the builder style.

*Help wanted! It is [open source][5].*

{{< highlight ruby >}}
class Application < Sinatra::Base

  enable :method_override
  enable :config_file

  PROPERTY_NAME = 'cardspring_browse.config_file'
  use Rack::Config do |env|
    env[PROPERTY_NAME] = settings.config_file
  end

  use CardspringBrowse::App::Publisher
  use CardspringBrowse::App::Users
  use CardspringBrowse::App::Events
  use CardspringBrowse::App::Businesses
  use CardspringBrowse::App::Apps
  use CardspringBrowse::App::Transactions

  def initialize(app, config_file = __FILE__)
    super(app)
    settings.config_file = config_file
  end

  get "/" do
    redirect to("/v1")
  end

end
{{< /highlight >}}

[1]: https://github.com/jjasonclark/cardspring_browse/blob/intro_blog_post/lib/cardspring_browse/application.rb#L15-L18
[2]: http://stackoverflow.com/questions/18320823/sharing-yaml-config-files-between-sinatra-and-rails
[3]: http:github.com/sinatra/sinatra
[4]: https://github.com/rack/rack/blob/master/lib/rack/config.rb
[5]: https://github.com/jjasonclark/cardspring_browse/blob/intro_blog_post/LICENSE.txt
[sinatra]: http://sinatrarb.com
[cardspring_browse]: https://github.com/jjasonclark/cardspring_browse
[rack]: http://github.com/rack/rack
