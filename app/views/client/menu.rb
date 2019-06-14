*@#{BOT_NICKNAME}*
`v.1.01`

#{t('client.menu.nickname')} `@#{hb_client.username}`
#{t('client.menu.balance')} *#{hb_client.balance}* `#{hb_client.currency}` / *#{hb_client.balance_in_btc}* `BTC`
#{t('client.menu.turnover')} *#{hb_client.trade_turnover}* `#{hb_client.currency}`
Курс *#{hb_client.btc_rate}* `USD`
#{t('client.menu.referals')} *#{ludey(hb_client.referals.count)}*
#{t('client.menu.earnings')} *#{hb_client.referals_earnings}* `USD`

#{t('client.menu.reputation')} ⭐️⭐️⭐️⭐️⭐️
#{t('client.menu.feedback')}🏻 56👎🏻 4
****
[
    [
        button('Мой адрес', 'receive_btc'),
        button('Отправить', 'send_btc')
    ],
    [
        button('Разместить объявление', 'create_ad')
    ]
]