require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'whenisthat.rb'

class WhenIsThatTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    WhenIsThat::Base.new
  end

  def test_loads_initial_page
    get '/'
    assert last_response.ok?
  end

  def test_simple_conversion
    post '/when', :q => "2pm MDT in CET"

    assert last_response.ok?
    assert last_response.body[0].include?("9:00PM CET")
  end

  def test_city_to_city
    post '/when', :q => "2pm Denver in Madrid"
    assert last_response.body[0].include?("9:00PM CET")
  end

  def test_city_to_code
    post '/when', :q => "2pm Denver in CET"
    assert last_response.body[0].include?("9:00PM CET")
  end

  def test_case_insensitivity
    post '/when', :q => "2pm dEnVER in CeT"
    assert last_response.body[0].include?("9:00PM CET")
  end

  def test_submitted_zone
    submit("2pm CET", "6")
    assert last_response.body[0].include?("07:00")
  end

  def test_non_o_clock
    submit("2 CET in MDT")
    assert last_response.body[0].include?("7:00PM MDT")
  end

  def test_to_instead_of_in
    post '/when', :q => "2pm Denver to CET"
    assert last_response.body[0].include?("9:00PM CET")
  end

  def test_whitespace
    submit("2pm   MDT    in    CET")
    assert last_response.body[0].include?("9:00PM CET")

    submit("2pm    CET", "6")
    assert last_response.body[0].include?("07:00")
  end

  def test_dots_in_pm
    submit("2p.m. CET", "6")
    assert last_response.body[0].include?("07:00")
  end

  def test_default_cities
    submit("2pm CET in Beijing")
    assert last_response.body[0].include?("9:00PM CST")
  end

  def test_alternative_syntax
    submit("2pm in CDT", "6")
    assert last_response.body[0].include?("1:00")
  end

  def test_utc
    submit("2pm MDT in UTC")
    assert last_response.body[0].include?("8:00")
  end

  def test_gmt
    submit("2pm MDT in GMT")
    assert last_response.body[0].include?("8:00")
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

  def submit(q, zone = "")
    post '/when', :q => q, :zone => zone
  end
end
