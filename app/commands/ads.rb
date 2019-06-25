module CRX
  module Commands
    module Ad

      def my_ads(data = nil)
        ads = hb_client.ads
        if ads.count == 0
          text = 'У Вас пока нет объявлений.'
        else
          text = 'Ваши объявления'
        end
        reply_inline 'ad/my_ads', ads: ads, text: text
      end

      def choose_ad_type(data = nil)
        handle('choose_ad_type')
        if !data
          reply_inline 'ad/choose_type'
        else
          ad = Ad.create(
              client: hb_client.id,
              type: data,
              status: Ad::INACTIVE
          )
          sset('ad', ad.id)
        end
      end

      def choose_currency(data = nil)
      end

      def enter_min(data = nil)
      end

      def enter_max(data = nil)
      end

      def enter_rate(data = nil)
      end

      def choose_ad_method(data = nil)
      end

    end
  end
end