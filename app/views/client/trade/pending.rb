#{icon('open_file_folder')} *Сделка ##{sget('trade')}*

Платежная система *#{Meth[sget('method')].title}*
Заблокировано #{usd(sget('amount'))}
Покупатель `@#{Client[sget('buyer').to_i].username}`

*Ваши реквизиты*
#{sget('details')}

Запрос на покупку был отправлен. Если в течение 5 минут мы не получим ответ, сделка будет отменена автоматически и средства будут разблокированы.
****
[
    [
        button("#{icon('no_entry_sign')} Отменить сделку", 'start_trade')
    ]
]
