Choose one of available *exchanges* from the list below.

Your trade amount *#{sget('zold_amount').to_zld} ZLD*
Exchange method *#{sget('zold_method').russian}*
Support [@Zold_bot_support](http://t.me/Zold_bot_support)
****
buts = []
@offers = Offer.all
buts = keyboard(@offers, 1) do |m|
  c = Client[m.client].username
  button("#{icon('bow')} #{c} #{coins_to_zld(m.reserve)} ZLD, #{m.ZLD_UAH} UAH/ZLD", m.id)
end
buts
