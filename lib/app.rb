require 'sinatra'
require 'sqlite3'

DB = SQLite3::Database.new(File.join(File.dirname(__FILE__), 'db/pocket_reader.sqlite'))

get '/' do
  "Hello World"
end