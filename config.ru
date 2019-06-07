require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require_rel './config/const'
require_rel './config/config'
require_rel './app/lib/tsx'
require_rel './app/lib'
require_rel './app/models'
require_rel './app/controllers/tsx'
require_rel './app/lib/tsx/games'
require_rel './app/controllers/ApplicationController'
require_rel './app/controllers'

`rake version:bump:revision`

begin
  require 'rack/timeout/base'
  use Rack::Timeout, service_timeout: 24, wait_timeout: 24, wait_overtime: 24
  use BotController
  use TSX::AuthController
  use TSX::AdminController
  use TSX::WallController
  use TSX::UserController
  run TSX::ApplicationController
rescue => e
  puts "EXCEPTION FROM CONFIG.RU ----------------"
  puts e.message
  puts e.backtrace.join("\t\n")
end