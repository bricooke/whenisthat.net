require 'rubygems'
require 'sinatra/base'
require 'activesupport'
require 'whenisthat/zone_conversion'

module WhenIsThat
  class Base < Sinatra::Base
    set :public, File.dirname(__FILE__) + "/public"
    set :static, true

    get '/' do
      haml :index, :locals => {:converted => nil, :q => nil}
    end

    get '/stylesheets/whenisthat.css' do
      headers 'Content-Type' => 'text/css; charset=utf-8'
      sass 'sass/whenisthat'.to_sym
    end

    get '/about' do
      haml :about
    end

    post '/when' do
      converted = ZoneConversion.convert(params["q"], params["zone"])
      haml :index, :locals => {:q => params["q"], :converted => (converted.nil? ? "Whoops. I don't understand." : converted)}
    end
  end
end
