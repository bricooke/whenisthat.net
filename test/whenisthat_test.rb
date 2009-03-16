require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'whenisthat.rb'
require 'whenisthat/zone_table.rb'

class WhenIsThatTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    WhenIsThat.new
  end

  def test_loads_initial_page
    get '/'
    assert last_response.ok?
  end

  def test_simple_conversion
    post '/when', :q => "2pm MDT in CET"

    assert last_response.ok?
    assert last_response.body[0].include?("21:00 CET")
  end

  def test_city_to_city
    post '/when', :q => "2pm Denver in Madrid"
    assert last_response.body[0].include?("21:00 CET")
  end

  def test_city_to_code
    post '/when', :q => "2pm Denver in CET"
    assert last_response.body[0].include?("21:00 CET")
  end

  def test_case_insensitivity
    post '/when', :q => "2pm dEnVER in CeT"
    assert last_response.body[0].include?("21:00 CET")
  end

  def test_unknown_destination
    post '/when', :q => "2pm MDT in CEE"
    assert last_response.ok?
    assert last_response.body[0].include?("Whoops")
  end

  def test_unknown_source
    post '/when', :q => "2pm Garbage in CET"
    assert last_response.ok?
    assert last_response.body[0].include?("Whoops")
  end
end
