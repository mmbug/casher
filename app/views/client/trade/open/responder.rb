#{icon('ticket')} *Сделка ##{@trade.id}*

Отправьте #{usd(@trade.amount)}, используя систему *#{@method.title}* на реквизиты, указанные ниже и подтвердите это.

*Реквизиты*
`#{@trade.details}`

#{icon('information_source')} Если пользователь не отпустит монеты после подтверждения перевода, Вы можете начать спор и тогда администрация системы начнет разбирательство.
****
[
    [
        button("#{icon('pencil2')} Сообщение", 'start_trade')
    ],
    [
        button("#{icon('anger')} Открыть спор", 'start_trade'),
    ],
    [
        button("#{icon('white_check_mark')} Подтердить перевод", 'start_trade'),
    ],
    [
        button("#{icon('no_entry_sign')} Отменить сделку", 'cancel_trade'),
    ]
]
