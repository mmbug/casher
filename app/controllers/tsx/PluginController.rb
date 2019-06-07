module TSX
  module Controllers
    module Plugin

      def save_referals(data = nil)
        put "SAVE REFERAL".blue

      end

      def save_voting(data = nil)
        return if !callback_query?
        gam = sget('tsx_game')
        gam.update(status: Gameplay::GAMEOVER)
        Vote.create(
            bot: @tsx_bot.id,
            username: hb_client.username
        )
        update_message "#{icon(@tsx_bot.icon_success)} Спасибо! Ваш голос очень важен, так как он участвует в голосовании за *Лучший Бот Месяца*. Лучший бот будет особо отмечен на странице *Рекомендуем*. Всего в этом месяце проголосовало *#{ludey(Vote::voted_this_month)}*."
      end

      def save_lottery(data = nil)
        put "SAVE REFERAL".blue
        gam = sget('tsx_game')
        gam.update(status: Gameplay::GAMEOVER)
        Bet.create(
            number: data.to_i,
            client: hb_client.id,
            game: gam.id
        )
        sdel('tsx_game')
        update_message "#{icon(@tsx_bot.icon_success)} Вы выбрали число *#{data}*. Когда рулетка закончится, победитель получит *#{@tsx_bot.amo(190)}*"
        # prize_lottery(gam)
      end

      def save_question(data = nil)
        Answer.create(
            answer: data.to_s,
            client: hb_client.id,
            game: @tsx_bot.active_game.id
        )
        update_message "#{icon(@tsx_bot.icon_success)} Вы поучаствовали в опросе клиентоа. Ваше мнение для нас важно!*."
      end

      def prize_lottery(game)
        puts "FINISH LOTTERY".blue
        puts "FINISH LOTTERY".blue
        puts "AVAILALBE: #{game.available_numbers}"
        if game.available_numbers.nil? or game.available_numbers.count < 1
          puts "FINISH LOTTERY".blue
          rec = Bet.where(game: game.id).limit(1).order(Sequel.lit('RANDOM()')).all
          winner = Client[rec.first.client]
          winner_num = Bet[rec.first.id].number
          game.winner = winner.id
          game.save
          @tsx_bot.say(winner.tele, "🚨🚨🚨 *Поздравляем!* Выбранный Вами номер *#{winner_num}* выиграл в рулетку! Вы получили *#{@tsx_bot.active_game.conf('prize')}*. Ждем в Аптеке всегда!")
          winner.cashin(@tsx_bot.active_game.conf('amount'), Client::__cash, Meth::__cash, @tsx_bot.beneficiary, "Выигрыш в рулетку. Победа числа *#{winner_num}*.")
          Spam.create(bot: @tsx_bot.id, kind: Spam::BOT_CLIENTS, label: 'Победа числа в лотерею', text: "🚨🚨🚨 Дорогие друзья! Победило число *#{winner_num}*. Клиенту с ником @#{winner.username} пополнен баланс на #{@tsx_bot.active_game.conf('amount')}", status: Spam::NEW)
          puts "DEACTIVATING GAME".colorize(:white_on_red)
          game.update(status: Gameplay::GAMEOVER)
        end
      end

      def play_game
        cur_game = Gameplay::fetchGame(@tsx_bot)
        if cur_game.nil?
          serp
          return
        end
        sset('tsx_game', cur_game)
        if cur_game.conf('question') == 'true'
          puts "CALLBACK".blue
          handle('save_game_res')
        else
          handle('add_filter')
        end
        reply_inline "welcome/#{cur_game.title}", gam: cur_game
      end

      def save_game_res(data = nil)
        gam = sget('tsx_game')
        if callback_query?
          puts "calling save_#{gam.title} method".blue
          send("save_#{gam.title}", data)
        else
          serp
        end
      end

    end
  end
end
