#{icon('ticket')} *Сделка ##{@trade.id}*

Пользователь *#{@responder.nickname}* должен перевести #{usd(@trade.amount)} на Ваши реквизиты в системе *#{@method.title}*. Как только это произойдет, Вы получите сообщение.

*Ваши реквизиты*
`#{@trade.details}`

#{icon('information_source')} Если средства не будут получены в течение *59 мин.*, сделка будет отменена автоматически. Также Вы можете через сообщение попросить покупателя отменить ее раньше.

#{icon('warning')} Просим Вас проводить сделки в переписке бота. В противном случае мы не сможем гарантировать сохранность средств.
****
[
    [
        button("#{icon('pencil2')} Сообщение", 'start_trade')
    ]
]
