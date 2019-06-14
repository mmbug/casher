require 'rubygems'
require 'telegram/bot'
resp = Faraday::get('https://t.me/benice24/56')
puts resp.inspect