require 'sinatra'
require './spreadsheet'

get '/' do
  sheet = SpreadSheet.new
  erb :index, locals: {'rows': sheet.rows }
end

after do
  headers({'Content-Security-Policy' => "frame-ancestors 'self' kakaxi.me kakaxi.jp flag.dispbox.com"})
end
