*💱 Личный кабинет и настройки.*
Заказывайте вывод заработанных средств. Все заявки будут обработаны в течение двух дней. Вывод делаем только стейблкойнами или криптой.

Клиент #{icon('id')} *#{hb_client.id}*
Баланс *#{@tsx_bot.amo(hb_client.available_cash)}*
Актуальная [#{hb_client.make_referal_link(@tsx_bot)}](#{hb_client.make_referal_link(@tsx_bot)})
Рефералов *#{ludey(hb_client.client_referals)}*
Реф продаж *#{hb_client.sales.count}* на *#{@tsx_bot.amo(hb_client.ref_sales)}*
Реферальные *#{@tsx_bot.get_var('ref_rate')}% с продажи*
Доступно для вывода *#{@tsx_bot.amo(hb_client.ref_cash)}*
****
help_buttons