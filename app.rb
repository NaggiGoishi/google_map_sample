require 'sinatra'
require './spreadsheet'

get '/' do
  sheet = SpreadSheet.new
  erb :index, locals: {'rows': sheet.rows }
end
