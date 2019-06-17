require 'openssl'
require 'colorize'

module CRX
  module Commands
    module Welcome

      def client_menu(data = nil)
        handle('client_menu')
        if !data
          reply_inline 'client/menu'
        else
          send(data.to_sym)
        end
      end

      def client_about
        reply_simple_with_photo 'logo.png', 'client/about'
      end

      def client_settings(data = nil)
        handle('client_settings')
        if !data
          reply_inline 'client/settings'
        else
          send(data.to_sym)
        end
      end

      def receive_btc
        reply_simple 'client/receive_btc'
      end

      def send_btc
        reply_simple 'client/send_btc'
      end

      def cancel
        reply_simple 'client/action_canceled'
        client_menu
      end

      def referal_link
        reply_update 'client/referal_link'
      end

      def change_currency
        reply_update 'client/change_currency'
      end

      def general_settings
        reply_update 'client/general_settings'
      end

    end
  end
end
