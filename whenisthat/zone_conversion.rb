require 'whenisthat/city'

module WhenIsThat
  class ZoneConversion
    ZONES = {
      :pdt => "Pacific Time (US & Canada)",
      :pst => "Pacific Time (US & Canada)",
      :mdt => "Mountain Time (US & Canada)",
      :mst => "Mountain Time (US & Canada)",
      :cdt => "Central Time (US & Canada)",
      :cst => "Central Time (US & Canada)",
      :edt => "Eastern Time (US & Canada)",
      :est => "Eastern Time (US & Canada)",
      :cet => "Madrid",
      :wet => "Lisbon",
      :west => "Lisbon",
      :nzdt => "Auckland",
      :nzst => "Auckland",
      :nzt => "Auckland",
      :jst => "Tokyo"
    }

    # mostly stolen from http://dev.rubyonrails.org/svn/rails/plugins/tzinfo_timezone/lib/tzinfo_timezone.rb
    # and reversed for my purposes. feels like i'm doing it wrong :/
    MAPPING = {
      "Boston" =>                                 "Eastern Time (US & Canada)"   ,
      "New York" =>                               "Eastern Time (US & Canada)"   ,
      "San Francisco" =>                          "Pacific Time (US & Canada)"   ,
      "SF" =>                                     "Pacific Time (US & Canada)"   ,
      "Austin" =>                                 "Central Time (US & Canada)"   ,
      "New Zealand" =>                            "Auckland"                     ,
      "Japan" =>                                  "Tokyo"                        ,      
      "Pacific/Midway" =>                         "International Date Line West" ,
      "Pacific/Midway" =>                         "Midway Island"                ,
      "Pacific/Pago_Pago" =>                      "Samoa"                        ,
      "Pacific/Honolulu" =>                       "Hawaii"                       ,
      "America/Juneau" =>                         "Alaska"                       ,
      "America/Los_Angeles" =>                    "Pacific Time (US & Canada)"   ,
      "America/Tijuana" =>                        "Tijuana"                      ,
      "America/Denver" =>                         "Mountain Time (US & Canada)"  ,
      "America/Phoenix" =>                        "Arizona"                      ,
      "America/Chihuahua" =>                      "Chihuahua"                    ,
      "America/Mazatlan" =>                       "Mazatlan"                     ,
      "America/Chicago" =>                        "Central Time (US & Canada)"   ,
      "America/Regina" =>                         "Saskatchewan"                 ,
      "America/Mexico_City" =>                    "Guadalajara"                  ,
      "America/Mexico_City" =>                    "Mexico City"                  ,
      "America/Monterrey" =>                      "Monterrey"                    ,
      "America/Guatemala" =>                      "Central America"              ,
      "America/New_York" =>                       "Eastern Time (US & Canada)"   ,
      "America/Indiana/Indianapolis" =>           "Indiana (East)"               ,
      "America/Bogota" =>                         "Bogota"                       ,
      "America/Lima" =>                           "Lima"                         ,
      "America/Lima" =>                           "Quito"                        ,
      "America/Halifax" =>                        "Atlantic Time (Canada)"       ,
      "America/Caracas" =>                        "Caracas"                      ,
      "America/La_Paz" =>                         "La Paz"                       ,
      "America/Santiago" =>                       "Santiago"                     ,
      "America/St_Johns" =>                       "Newfoundland"                 ,
      "America/Argentina/Buenos_Aires" =>         "Brasilia"                     ,
      "America/Argentina/Buenos_Aires" =>         "Buenos Aires"                 ,
      "America/Argentina/San_Juan" =>             "Georgetown"                   ,
      "America/Godthab" =>                        "Greenland"                    ,
      "Atlantic/South_Georgia" =>                 "Mid-Atlantic"                 ,
      "Atlantic/Azores" =>                        "Azores"                       ,
      "Atlantic/Cape_Verde" =>                    "Cape Verde Is."               ,
      "Europe/Dublin" =>                          "Dublin"                       ,
      "Europe/Dublin" =>                          "Edinburgh"                    ,
      "Europe/Lisbon" =>                          "Lisbon"                       ,
      "Europe/London" =>                          "London"                       ,
      "Africa/Casablanca" =>                      "Casablanca"                   ,
      "Africa/Monrovia" =>                        "Monrovia"                     ,
      "Europe/Belgrade" =>                        "Belgrade"                     ,
      "Europe/Bratislava" =>                      "Bratislava"                   ,
      "Europe/Budapest" =>                        "Budapest"                     ,
      "Europe/Ljubljana" =>                       "Ljubljana"                    ,
      "Europe/Prague" =>                          "Prague"                       ,
      "Europe/Sarajevo" =>                        "Sarajevo"                     ,
      "Europe/Skopje" =>                          "Skopje"                       ,
      "Europe/Warsaw" =>                          "Warsaw"                       ,
      "Europe/Zagreb" =>                          "Zagreb"                       ,
      "Europe/Brussels" =>                        "Brussels"                     ,
      "Europe/Copenhagen" =>                      "Copenhagen"                   ,
      "Europe/Madrid" =>                          "Madrid"                       ,
      "Europe/Paris" =>                           "Paris"                        ,
      "Europe/Amsterdam" =>                       "Amsterdam"                    ,
      "Europe/Berlin" =>                          "Berlin"                       ,
      "Europe/Berlin" =>                          "Bern"                         ,
      "Europe/Rome" =>                            "Rome"                         ,
      "Europe/Stockholm" =>                       "Stockholm"                    ,
      "Europe/Vienna" =>                          "Vienna"                       ,
      "Africa/Algiers" =>                         "West Central Africa"          ,
      "Europe/Bucharest" =>                       "Bucharest"                    ,
      "Africa/Cairo" =>                           "Cairo"                        ,
      "Europe/Helsinki" =>                        "Helsinki"                     ,
      "Europe/Kiev" =>                            "Kyev"                         ,
      "Europe/Riga" =>                            "Riga"                         ,
      "Europe/Sofia" =>                           "Sofia"                        ,
      "Europe/Tallinn" =>                         "Tallinn"                      ,
      "Europe/Vilnius" =>                         "Vilnius"                      ,
      "Europe/Athens" =>                          "Athens"                       ,
      "Europe/Istanbul" =>                        "Istanbul"                     ,
      "Europe/Minsk" =>                           "Minsk"                        ,
      "Asia/Jerusalem" =>                         "Jerusalem"                    ,
      "Africa/Harare" =>                          "Harare"                       ,
      "Africa/Johannesburg" =>                    "Pretoria"                     ,
      "Europe/Moscow" =>                          "Moscow"                       ,
      "Europe/Moscow" =>                          "St. Petersburg"               ,
      "Europe/Moscow" =>                          "Volgograd"                    ,
      "Asia/Kuwait" =>                            "Kuwait"                       ,
      "Asia/Riyadh" =>                            "Riyadh"                       ,
      "Africa/Nairobi" =>                         "Nairobi"                      ,
      "Asia/Baghdad" =>                           "Baghdad"                      ,
      "Asia/Tehran" =>                            "Tehran"                       ,
      "Asia/Muscat" =>                            "Abu Dhabi"                    ,
      "Asia/Muscat" =>                            "Muscat"                       ,
      "Asia/Baku" =>                              "Baku"                         ,
      "Asia/Tbilisi" =>                           "Tbilisi"                      ,
      "Asia/Yerevan" =>                           "Yerevan"                      ,
      "Asia/Kabul" =>                             "Kabul"                        ,
      "Asia/Yekaterinburg" =>                     "Ekaterinburg"                 ,
      "Asia/Karachi" =>                           "Islamabad"                    ,
      "Asia/Karachi" =>                           "Karachi"                      ,
      "Asia/Tashkent" =>                          "Tashkent"                     ,
      "Asia/Calcutta" =>                          "Chennai"                      ,
      "Asia/Calcutta" =>                          "Kolkata"                      ,
      "Asia/Calcutta" =>                          "Mumbai"                       ,
      "Asia/Calcutta" =>                          "New Delhi"                    ,
      "Asia/Katmandu" =>                          "Kathmandu"                    ,
      "Asia/Dhaka" =>                             "Astana"                       ,
      "Asia/Dhaka" =>                             "Dhaka"                        ,
      "Asia/Dhaka" =>                             "Sri Jayawardenepura"          ,
      "Asia/Almaty" =>                            "Almaty"                       ,
      "Asia/Novosibirsk" =>                       "Novosibirsk"                  ,
      "Asia/Rangoon" =>                           "Rangoon"                      ,
      "Asia/Bangkok" =>                           "Bangkok"                      ,
      "Asia/Bangkok" =>                           "Hanoi"                        ,
      "Asia/Jakarta" =>                           "Jakarta"                      ,
      "Asia/Krasnoyarsk" =>                       "Krasnoyarsk"                  ,
      "Asia/Shanghai" =>                          "Beijing"                      ,
      "Asia/Chongqing" =>                         "Chongqing"                    ,
      "Asia/Hong_Kong" =>                         "Hong Kong"                    ,
      "Asia/Urumqi" =>                            "Urumqi"                       ,
      "Asia/Kuala_Lumpur" =>                      "Kuala Lumpur"                 ,
      "Asia/Singapore" =>                         "Singapore"                    ,
      "Asia/Taipei" =>                            "Taipei"                       ,
      "Australia/Perth" =>                        "Perth"                        ,
      "Asia/Irkutsk" =>                           "Irkutsk"                      ,
      "Asia/Ulaanbaatar" =>                       "Ulaan Bataar"                 ,
      "Asia/Seoul" =>                             "Seoul"                        ,
      "Asia/Tokyo" =>                             "Osaka"                        ,
      "Asia/Tokyo" =>                             "Sapporo"                      ,
      "Asia/Tokyo" =>                             "Tokyo"                        ,
      "Asia/Yakutsk" =>                           "Yakutsk"                      ,
      "Australia/Darwin" =>                       "Darwin"                       ,
      "Australia/Adelaide" =>                     "Adelaide"                     ,
      "Australia/Melbourne" =>                    "Canberra"                     ,
      "Australia/Melbourne" =>                    "Melbourne"                    ,
      "Australia/Sydney" =>                       "Sydney"                       ,
      "Australia/Brisbane" =>                     "Brisbane"                     ,
      "Australia/Hobart" =>                       "Hobart"                       ,
      "Asia/Vladivostok" =>                       "Vladivostok"                  ,
      "Pacific/Guam" =>                           "Guam"                         ,
      "Pacific/Port_Moresby" =>                   "Port Moresby"                 ,
      "Asia/Magadan" =>                           "Magadan"                      ,
      "Asia/Magadan" =>                           "Solomon Is."                  ,
      "Pacific/Noumea" =>                         "New Caledonia"                ,
      "Pacific/Fiji" =>                           "Fiji"                         ,
      "Asia/Kamchatka" =>                         "Kamchatka"                    ,
      "Pacific/Majuro" =>                         "Marshall Is."                 ,
      "Pacific/Auckland" =>                       "Auckland"                     ,
      "Pacific/Auckland" =>                       "Wellington"                   ,
      "Pacific/Tongatapu" =>                      "Nuku'alofa"
    }

    def self.convert(in_string, zone="")
      begin
        time, from_zone, to_zone = in_string.scan(/(\S+)\s+([\S\s]+)\s+[in|to]+\s+([\S\s]+)/i)[0]

        # try support for 2pm in Chicago and use the browser
        # or
        # try support for 2pm MDT and use the browser default
        if time.nil?
          time, from_zone = in_string.scan(/(\S+)\s+[in|\s+]*([\S\s]+)/i)[0]
          time = cleanup_time(time)
          offset = zone.to_f

          Time.zone = ZoneConversion.zone_to_city(from_zone.downcase.to_sym)
          raise "unknown city #{from_zone}" if Time.zone.nil?

          offset += (Time.zone.now.utc_offset.to_f/60.0/60.0)
          converted = (Time.zone.parse(time) - offset.hours)
          converted = converted.strftime("%I:%M%p") + " your time"
        else
          time = cleanup_time(time)
          from_zone = from_zone.downcase
          to_zone = to_zone.downcase

          [to_zone, from_zone].each do |zone|
            Time.zone = ZoneConversion.zone_to_city(zone.downcase.to_sym)
            raise "unknown city #{zone}" if Time.zone.nil?
          end
          converted =  Time.zone.parse(time).in_time_zone(ZoneConversion.zone_to_city(to_zone.to_sym))
          converted = converted.strftime("%I:%M%p %Z")
        end

        converted = "That would be " + converted
      rescue Exception => e
        converted = nil
      end
      converted
    end

    def self.zone_to_city(zone)
      return ZONES[zone] unless ZONES[zone].nil?
      MAPPING.keys.each do |city|
        return MAPPING[city] if city.downcase == zone.to_s.downcase || city.downcase.include?("/" + zone.to_s.downcase)
      end

      # handle utc and gmt special
      if zone.to_s.downcase == "gmt" || zone.to_s.downcase == "utc"
        return "UTC"
      end

      zone.to_s.humanize
    end


    protected
    def self.cleanup_time(time)
      time = time.downcase
      if time.scan(/[a|p][\.]*m[\.]*/).empty? && !time.include?(":")
        time = time + ":00"
      end
      time
    end
  end
end

