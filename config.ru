require 'rubygems'
require 'rack'
require 'rack/contrib'
require 'whenisthat.rb'

use Rack::ETag
use WhenIsThat::Base
run Rack::NotFound.new("./views/404.html")
