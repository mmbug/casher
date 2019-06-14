class CRXBot
  attr_accessor :token, :tele, :id

  def initialize(token, tele, id)
    @token = token
    @tele = tele
    @id = id
  end
end

class CRXController < Sinatra::Base

  use Rack::Session::Cookie, secret: 'sbddddjfttsxtsxpostsetsession789999333hhjgg'

  register Sinatra::Reloader if not production?
  also_reload "#{ROOT}/app/models/*" if not production?

  include Telegram::Bot::Types
  include ActionView::Helpers::DateHelper
  include CRX::Exceptions
  include CRX::Context
  include CRX::Helpers
  include CRX::Reply
  include CRX::Payload

  include Zold::Commands::Welcome
  include Zold::Commands::Registration
  include Zold::Commands::Trade

  Telegram::Bot.configure do |config|
    config.adapter = :net_http_persistent
  end

  set views: "#{ROOT}/app/views"
  set public_folder: "#{ROOT}/public"

  post'/*' do
    begin
      @tsx_bot = CRXbot.new("472907202:AAGNCX_0XRJ3r6b6MdcDurFp2Ios5Yvq4Bs", 'Zold', 1) if settings.production?
      @bot = Telegram::Bot::Client.new("472907202:AAGNCX_0XRJ3r6b6MdcDurFp2Ios5Yvq4Bs") if settings.production?
      @tsx_bot = CRXBot.new("872035575:AAEW_op6UnEF6goFIANIU2ApGcLXWueO3xc", 'CRX24', 1) if settings.development?
      @bot = Telegram::Bot::Client.new("872035575:AAEW_op6UnEF6goFIANIU2ApGcLXWueO3xc") if settings.development?
      parse_update(request.body)
      setup_sessa
      define_language
      show_typing
      call_handler
      log_update
    rescue => ex
      puts "====================================="
      puts ex.message
      puts ex.backtrace.join("\n\t")
      puts "====================================="
    end
    [200, {}, ["----------------------- SUCCESS"]]
  end

end
