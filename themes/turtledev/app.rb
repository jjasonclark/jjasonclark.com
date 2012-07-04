# Use the app.rb file to load Ruby code, modify or extend the models, or
# do whatever else you fancy when the theme is loaded.

module Nesta
  class App
    # Uncomment the Rack::Static line below if your theme has assets
    # (i.e images or JavaScript).
    #
    # Put your assets in themes/turtledev/public/turtledev.
    #
    use Rack::Static, :urls => ["/turtledev"], :root => "themes/turtledev/public"

    helpers do
      # Add new helpers here.
    end

    def enable_comments?
      @page.flagged_as?('commented')
    end

    # Add new routes here.
  end
end
