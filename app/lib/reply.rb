module CRX
  module Reply

    def fixture(file_name)
      File.expand_path("#{ROOT}/public/images/#{file_name}", __FILE__)
    end

    def reply_picture (filename, caption, who = nil)
      file = Telebot::InputFile.new(fixture(filename), 'image/jpeg')
      @bot.api.send_photo(chat_id: !who.nil? ? who.tele : chat, photo: file, caption: caption)
    end

    def delete_message(id)
      @bot.api.public_send(
        "delete_message",
        chat_id: chat,
        message_id: id
      )
    end

    def reply_inline(view, locals = {})
      v = render_md(view, locals)
      buts = Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: v.buttons
      )
      res = @bot.api.send_message(
          chat_id: chat,
          text: v.body,
          parse_mode: :markdown,
          reply_markup: buts,
          disable_web_page_preview: true,
          one_time_keyboard: false
      )
      set_editable(res['result']['message_id'])
      puts "SET EDITABLE: #{has_editable?}"
    end

    def reply_update(view, locals = {})
      v = render_md(view, locals)
      buts = Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: v.buttons
      )
      puts "HAS EDITABLE: #{has_editable?}"
      begin
        if message_id - has_editable? > 1
          raise
        end
        res = @bot.api.public_send(
            "edit_message_text",
            chat_id: !@who.nil? ? @who.tele : chat,
            message_id: has_editable?,
            text: v.body,
            parse_mode: :markdown,
            reply_markup: buts,
            disable_web_page_preview: true
        )
        set_editable(res['result']['message_id'])
      rescue => ex
        puts ex.message.colorize(:red)
        if block_given?
          yield locals, ex
        end
      end
    end

    def send_inv(amount)
      p1 = JSON.generate([{amount: amount, label: 'Zerocracy.com Donation'}])
      puts p1.inspect
      ff = @bot.api.send_invoice(
        chat_id: chat,
        title: 'Zerocracy',
        description: 'деск',
        start_parameter: '3didus',
        payload: Time.now.to_i.to_s,
        provider_token: '361519591:TEST:1204c3405c08bf7f66683ce0b697b758',
        currency: 'USD',
        prices: p1
      )
      puts ff.inspect
    end

    def update_with_view(view, locals = {})
      v = render_md(view, locals)
      res = @bot.api.public_send(
          "edit_message_text",
          chat_id: !@who.nil? ? @who.tele : chat,
          message_id: has_editable?,
          text: v.body,
          parse_mode: :markdown,
          reply_markup: nil
      )
      set_editable(res['result']['message_id'])
    end

    def update_message(mess)
      buts = Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: nil
      )
      begin
        res = @bot.api.public_send(
            "edit_message_text",
            chat_id: chat,
            message_id: has_editable?,
            text: mess,
            parse_mode: :markdown,
            reply_markup: buts
        )
        set_editable(res['result']['message_id'])
      rescue => ex
        puts ex.message
        puts ex.backtrace
        if block_given?
          yield ex
        end
      end
    end

    def answer_callback(text)
      if callback_query?
        @bot.api.public_send(
            "answer_callback_query",
            callback_query_id: @payload.id,
            text: text
        )
      end
    end

    def reply_location(txt)
      buts = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard: [[text: 'Отослать геопозицию', request_location: true]],
          resize_keyboard: true,
      )
      @bot.api.send_message(
          chat_id: chat,
          text: txt,
          reply_markup: buts
      )

    end

    def reply_plain (view, locals = {})
      v = render_md(view, locals)
      buts = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard: v.buttons,
          resize_keyboard: locals[:resize].nil?,
          one_time_keyboard: (!locals[:one_time].nil?)
      )
      @bot.api.send_message(
        chat_id: chat,
        text: v.body,
        reply_markup: buts,
        disable_web_page_preview: true
      )
    end

    def reply_simple_with_photo (filename, view, locals = {})
      file = Telebot::InputFile.new(fixture(filename), 'image/jpeg')
      v = render_md(view, locals)
      if @remove_keyboard
        buts = Telegram::Bot::Types::ReplyKeyboardRemove.new(
            remove_keyboard: true
        )
      else
        buts = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
            keyboard: v.buttons,
            resize_keyboard: true,
            one_time_keyboard: !@one_time ? false : true
        )
      end
      if @links.nil?
        wlinks = true
      elsif @links == false
        wlinks = true
      else
        wlinks = false
      end
      puts buts.inspect
      puts v.body.inspect
      res = @bot.api.send_photo(
          chat_id: !@who.nil? ? @who.tele : chat,
          photo: file,
          caption: v.body,
          parse_mode: :markdown,
          reply_markup: buts,
          disable_web_page_preview: wlinks
      )
    end


    def reply_simple (view, locals = {})
      v = render_md(view, locals)
      if @remove_keyboard
        buts = Telegram::Bot::Types::ReplyKeyboardRemove.new(
            remove_keyboard: true
        )
      else
        buts = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard: v.buttons,
          resize_keyboard: true,
          one_time_keyboard: !@one_time ? false : true
        )
      end
      if @links.nil?
        wlinks = true
      elsif @links == false
        wlinks = true
      else
        wlinks = false
      end
      puts buts.inspect
      puts v.body.inspect
      res = @bot.api.send_message(
          chat_id: !@who.nil? ? @who.tele : chat,
          text: v.body,
          parse_mode: :markdown,
          reply_markup: buts,
          disable_web_page_preview: wlinks
      )
    end

    def send_item (view, locals = {})
      v = render_md(view, locals)
      buts = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard: v.buttons,
          resize_keyboard: true,
          one_time_keyboard: false
      )
      @bot.api.send_message(
          chat_id: chat,
          text: v.body,
          reply_markup: buts
      )
    end

    def just_take(item)
      @bot.api.send_message(
          chat_id: chat,
          text: item.photo
      )
    end

    def notify(cmd, btns = nil)
      reply_message("#{cmd}.", hb_client, btns)
    end

    def notified(mess)
      reply_message("#{icon(('ok'))} #{mess}", hb_client, nil)
    end

    def reply_message(mess, btns = nil, one_time_keyboard = false)
      v = CRX::View.new(mess, btns)
      if !btns.nil?
        buts = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
            keyboard: btns.nil? ? nil : v.buttons
        )
      end
      res = @bot.api.send_message(
        chat_id: chat,
        reply_markup: buts,
        text: v.body,
        parse_mode: :markdown,
        one_time_keyboard: one_time_keyboard ? true : false
      )
    end

    def say(who, text)
      @bot.api.send_message(
        chat_id: who.tele,
        text: text,
        parse_mode: :markdown
      )
    end

    def show_typing
      @bot.api.public_send(
          "send_chat_action",
          chat_id: chat,
          action: :typing
      )
    end

    def reply_error(locals = {})
      view = render_md('errors/internal', locals)
      @bot.api.send_message(
          chat_id: chat,
          text: view.body,
          reply_markup: {
              keyboard: view.buttons,
              resize_keyboard: false,
              one_time_keyboard: false
          },
          parse_mode: :markdown
      )
    end

    def render_md(v, locals = {})
      if !File.exist?("#{ROOT}/app/views/#{v}.rb")
        CRX::View.new('Невозможно обработать запрос.', ["Settings"])
      else
        locals.each do |var, val|
          instance_variable_set("@#{var}".to_sym, val)
        end
        puts v.colorize(:red)
        template = File.read("#{ROOT}/app/views/#{v}.rb")
        b, bt = template.split('****')
        CRX::View.new(
            instance_eval('"' + b + '"'),
            instance_eval(bt)
        )
      end
    end

  end
end