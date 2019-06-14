require 'openssl'
require 'colorize'
require 'sibit'

module Zold
  module Commands
    module Registration

      def ask_agreement
        reply_simple 'welcome/agreement'
      end

      def ask_language
        reply_simple 'welcome/language'
      end

      def set_client_english
        hb_client.update(lang: 'EN')
        ask_agreement
      end

      def set_client_russian
        hb_client.update(lang: 'RU')
        ask_agreement
      end

      def client_sign
        sibit = Sibit.new
        pkey = sibit.generate
        address = sibit.create(pkey)
        price = sibit.price
        puts "BTC price: #{price}"
        hb_client.update(signed: 1, btc_address: address, btc_pkey: pkey)
        welcome
        client_menu
      end

    end
  end
end
