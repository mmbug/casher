*🎨  Продать BTC*

Вы собираетесь продать `BTC` с баланса своего кошелька.
Сумма #{usd(sget('amount'))}
Доступно #{usd(hb_client.balance)}

Выберите покупателя из списка. Все покупатели активны и готовы ответить на запрос.
****
buts ||= []
@avlbl = hb_client.available_sellers
buts = keyboard(@avlbl, 2) do |rec|
    puts rec.inspect
    button("#{rec[:username]}, #{rec[:rate]} USD", 1)
end
