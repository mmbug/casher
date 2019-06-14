*🎨  Продать*

Вы собираетесь продать `BTC` на сумму #{usd(sget('amount'))} через электронную систему *#{Meth[sget('method')].title}*. Выберите покупателя из списка.
****
buts ||= []
@avlbl = hb_client.available_sellers
buts = keyboard(@avlbl, 2) do |rec|
    button("#{icon('sunglasses')} #{rec[:username]}, #{rec[:rate]} USD", 1)
end
