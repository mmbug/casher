require 'openssl'
require 'colorize'

module Zold
  module Commands
    module Sell

      def choose_seller
        reply_inline 'client/trade/choose_seller'
      end

    end
  end
end
