require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'active_support'
require 'active_support/all'
require 'active_support/core_ext'
require 'action_view/helpers'
require 'colorize'
require 'sinatra/base'
require 'sinatra/reloader'
require 'faraday_middleware'
require 'json'
require 'faraday'
require 'rack'
require 'active_support'
require 'action_view'
require 'telegram/bot'
require 'telegram/bot/exceptions'
require 'net/http/persistent'

require_rel './config/const'
require_rel './config/config'
require_rel './app/lib'
require_rel './app/commands'
require_rel './app/models'
require_rel './app/controllers'

`rake version:bump:revision`

begin
  run CRXController
rescue => e
  puts e.message
  puts e.backtrace.join("\t\n")
end