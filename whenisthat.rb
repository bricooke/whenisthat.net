require 'rubygems'
require 'sinatra/base'
require 'activesupport'
require 'whenisthat/zone_table'

class WhenIsThat < Sinatra::Base
  set :public, File.dirname(__FILE__) + "/public"
  set :static, true

  get '/' do
    haml :index, :locals => {:converted => nil, :q => nil}
  end

  get '/stylesheets/whenisthat.css' do
    headers 'Content-Type' => 'text/css; charset=utf-8'
    sass 'sass/whenisthat'.to_sym
  end

  post '/when' do
    begin
      time, from_zone, to_zone = params["q"].scan(/(.*) (.*) in (.*)/i)[0]

      from_zone = from_zone.downcase
      to_zone = to_zone.downcase

      [to_zone, from_zone].each do |zone|
        Time.zone = ZoneTable.zone_to_city(zone.downcase.to_sym)
        Time.zone = zone if Time.zone.nil?
        raise "unknown city #{zone}" if Time.zone.nil?
      end

      converted = "That would be " + Time.zone.parse(time).in_time_zone(ZoneTable.zone_to_city(to_zone.to_sym)).strftime("%H:%M %Z")
    rescue Exception => e
      converted = nil
    end
    haml :index, :locals => {:q => params["q"], :converted => (converted.nil? ? "Whoops. I don't understand." : converted)}
  end
end

