require 'rubygems'
require 'telegram/bot'
hook = 'https://fce5bfa4.ngrok.io/856978609:AAFxVC5RgBIhkEtwaEir7iIA4klHVNhfLYM'
from_bot = Telegram::Bot::Api.new('856978609:AAFxVC5RgBIhkEtwaEir7iIA4klHVNhfLYM')
puts from_bot.setWebhook(url: hook)
