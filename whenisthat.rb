require 'rubygems'
require 'sinatra/base'
require 'activesupport'
require 'whenisthat/db'
require 'whenisthat/zone_conversion'
require 'rack-flash'

module WhenIsThat
  class Base < Sinatra::Base
    use Rack::Session::Cookie
    use Rack::Flash

    set :public, File.dirname(__FILE__) + "/public"
    set :static, true

    get '/' do
      if (params["q"])
        converted = ZoneConversion.convert(params["q"], params["zone"])
        haml :index, :locals => {:q => params["q"], :converted => (converted.nil? ? "Whoops. I don't understand." : converted)}
      else
        haml :index, :locals => {:converted => nil, :q => nil}
      end
    end

    get '/about' do
      haml :about
    end

    post '/when' do
      converted = ZoneConversion.convert(params["q"], params["zone"])
      haml :index, :locals => {:q => params["q"], :converted => (converted.nil? ? "Whoops. I don't understand." : converted)}
    end

    get '/cities/new' do
      haml 'cities/new'.to_sym
    end

    post '/cities' do
      if params["name"].blank?
        haml 'cities/new'.to_sym
      else
        City.create({
                      :source_city => params["name"],
                      :from_email => params["from_email"]
                    })
        flash[:notice] = "Thanks, I'll get on that!"
        redirect '/'
      end
    end

    get '/stylesheets/whenisthat.css' do
      headers 'Content-Type' => 'text/css; charset=utf-8'
      sass 'sass/whenisthat'.to_sym
    end
  end
end
