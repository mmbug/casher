#{icon('ticket')} *Сделка ##{@trade.id}*

Обмен *#{Client[sget('responder').to_i].nickname}*
Отзывы #{icon('+1')} 56 #{icon('-1')} 8

Обмен *BTC* #{icon('arrow_right')} *#{Meth[sget('method')].title}*
Сумма сделки #{usd(@trade.amount)}

****
[
    [
        button("#{icon('pencil2')} Сообщение", 'start_trade')
    ]
]
