#{icon('currency_exchange')} *#{Meth[@trade.meth].russian} exchange ##{@trade.id}*
This buying operation will be processed automatically. Just follow instructions provided by other members of the system.

Seller #{Client[@trade.seller].username}
Reserve *#{coins_to_zld(@offer.reserve)} ZLD*

Banking details *#{@offer.card}*
Bank name *PrivatBank, UA*
Amount *#{coins_to_zld(@trade.amount)} ZLD*
Rate *#{@offer.ZLD_UAH} UAH / 1 ZLD*
To pay `#{(coins_to_zld(@trade.amount).to_f * @offer.ZLD_UAH.to_f).round} UAH`

Support [@Zold_bot_support](http://t.me/Zold_bot_support)
FAQs /zoldexchangefaqs

---
___#{@offer.details}___
****
# [[button("#{icon('heavy_check_mark')} Confirm payment", 'confirm_payment')]]
[["#{icon('heavy_check_mark')} Payment sent", "#{icon('no_entry')} Cancel"]]