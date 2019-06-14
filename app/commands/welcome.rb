require 'openssl'
require 'colorize'

module Zold
  module Commands
    module Welcome

      def start
        if !hb_client.signed?
          ask_agreement
        else
          client_menu
        end
      end

      def welcome
        reply_simple_with_photo 'logo.png', 'welcome/welcome'
      end

      def no_command
        reply_message 'No command'
      end

    end
  end
end
