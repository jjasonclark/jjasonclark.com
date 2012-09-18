require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

require 'nesta/env'
Nesta::Env.root = ::File.expand_path('.', ::File.dirname(__FILE__))

require 'nesta/app'

use Rack::Codehighlighter, :coderay, :element => "pre>code", :pattern => /\A\s*:::(\w+)\s*(\n|&#x000A;)/i, :markdown => true, :logging => false

run Nesta::App
