🎲🎲 *Рулетка!* 🎲🎲 Выберите номер, чтобы участвовать в игре. Это бесплатно. Победитель получит *#{@tsx_bot.amo(@gam.conf('prize'))}* Победитель будет объявлен отдельно.
****
buts ||= []
avlbl_numbers = @gam.available_numbers
buts = keyboard(avlbl_numbers.to_a, 5) do |rec|
    button("🔸 #{rec}", rec)
end
buts
