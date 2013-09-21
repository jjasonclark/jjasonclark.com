require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

use Rack::ConditionalGet
use Rack::ETag
use Rack::ContentLength
use Rack::Static, :urls => ["/images", "/javascripts"], :root => "public"

require 'nesta/env'
Nesta::Env.root = ::File.expand_path('.', ::File.dirname(__FILE__))

require 'nesta/app'

use Rack::Codehighlighter,
    :ultraviolet,
    :lines => false,
    :element => "pre>code",
    :theme => "iplastic",
    :pattern => /\A\s*:::([^\n\r]+)\s*[\n\r]/i,
    :markdown => true,
    :logging => false

run Nesta::App
