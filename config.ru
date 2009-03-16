require 'rubygems'
require 'rack'
require 'rack/contrib'
require 'whenisthat.rb'

use Rack::ETag
use WhenIsThat
run Rack::NotFound.new("./views/404.html")
