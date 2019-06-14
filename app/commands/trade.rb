require 'openssl'
require 'colorize'

module Zold
  module Commands
    module Trade

      def buy_amount(data = nil)
        if hb_client.balance == 0
          reply_message "#{icon('warning')} На Вашем балансе недостаточно средств для продажи. Ваш баланс #{balance}"
        else
          handle('buy_amount')
          if !data
            reply_message 'Введите сумму в `USD`.'
          else
            sset('amount', data)
            choose_method
          end
        end
      end

      def choose_method
        reply_inline 'client/trade/choose_method'
      end

      def choose_seller
        reply_inline 'client/trade/choose_seller'
      end

    end
  end
end
