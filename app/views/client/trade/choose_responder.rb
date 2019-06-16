Выберите покупателя из списка.
****
buts ||= []
@avlbl = hb_client.available_sellers
buts = keyboard(@avlbl, 1) do |rec|
    client = Client[rec[:client]]
    ad = Ad[rec[:ad]]
    button("#{icon('sunglasses')} #{client.username}, #{ad.rate} USD", ad.id)
end
