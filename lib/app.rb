require 'sinatra'
require 'sqlite3'

require_relative './models/author'
require_relative './models/post'

DB = SQLite3::Database.new(File.join(File.dirname(__FILE__), 'db/pocket_reader.sqlite'))

get '/' do
  "Hello World"
end
