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

  get '/about' do
    haml :about
  end

  post '/when' do
    converted = nil
    begin
      time, from_zone, to_zone = params["q"].scan(/(\S+)\s+(\S+)\s+[in|to]+\s+(\S+)/i)[0]

      # try support for 2pm MDT and use the browser default
      if time.nil?
        time, from_zone = params["q"].scan(/(\S+)\s+(\S+)/i)[0]
        time = cleanup_time(time)
        offset = params["zone"].to_f

        Time.zone = ZoneTable.zone_to_city(from_zone.downcase.to_sym)
        raise "unknown city #{from_zone}" if Time.zone.nil?

        offset += Time.zone.utc_offset.to_f/60.0/60.0

        converted = (Time.zone.parse(time) - offset.hours).strftime("%H:%M") + " your time"
      else
        time = cleanup_time(time)
        from_zone = from_zone.downcase
        to_zone = to_zone.downcase

        [to_zone, from_zone].each do |zone|
          Time.zone = ZoneTable.zone_to_city(zone.downcase.to_sym)
          raise "unknown city #{zone}" if Time.zone.nil?
        end
        converted = Time.zone.parse(time).in_time_zone(ZoneTable.zone_to_city(to_zone.to_sym)).strftime("%H:%M %Z")
      end

      converted = "That would be " + converted
    rescue Exception => e
      converted = nil
    end
    haml :index, :locals => {:q => params["q"], :converted => (converted.nil? ? "Whoops. I don't understand." : converted)}
  end

  protected
  def cleanup_time(time)
    time = time.downcase
    if time.scan(/[a|p][\.]*m[\.]*/).empty? && !time.include?(":")
      time = time + ":00"
    end
    time
  end
end

