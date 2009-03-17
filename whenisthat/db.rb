require 'rubygems'
require 'sequel'

uri = 'sqlite://whenisthat/db/wit.sqlite3'
DB = Sequel.connect(uri)
