require 'rubygems'
require 'telegram/bot'
resp = Faraday.get('https://uinames.com/api/?region=england&maxlen=8').body
resp_hash = JSON.parse(resp)

puts "#{resp_hash['name']}#{resp_hash['surname']}"