#{@text}
****
buts ||= []
buts = keyboard(@ads, 1) do |rec|
  button("#{t("ads.#{rec[:type]}")} по #{rec[:rate]} #{rec[:currency]}", rec[:id])
end
buts << [button('Добавить', 'create_ad')]
