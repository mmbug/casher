module CRX
  module Helpers

    def icn(code, big = "emoji")
      Twemoji.parse(":#{code}:", class_name: big)
    end

    def icon(code, text = '')
      unic = Twemoji.find_by_text(":#{code}:")
      if unic
        "#{Twemoji.render_unicode(unic)} #{text}"
      else
        icon('white_small_square', text)
      end
    end

    def icon_unicode(code)
      ccc = Twemoji.find_by(code: code)
      Twemoji.render_unicode ccc
    end

    def location(url)
      "location.href='#{url(url)}'"
    end

    def current_locale
      I18n.locale
    end

    def human_date(d)
      d.nil? ? 'n/a' : d.to_time.strftime("%b %d, %Y")
    end

    def zld(amount)
      "#{Zold::Amount.new(zld: amount).to_zld}"
    end

    def coins_to_zld(coins)
      "#{Zold::Amount.new(coins: coins).to_zld}"
    end

    def satoshi_to_usd(sat, price)
      in_btc = sat.to_d / 100000000
      in_usd = in_btc * price
      in_usd.round(2)
    end

    def satoshi_to_btc(sat, price)
      sat.to_d / 100000000
    end

    def human_date_short(d)
      d.nil? ? 'n/a' : d.to_time.strftime("%b %d")
    end

    def human_time(d)
      d.nil? ? 'n/a' : d.to_time.strftime("%H:%M")
    end

    def t(key, options = nil)
      I18n.translate(key, options)
    end

    def ago(dat)
      distance_of_time_in_words(Time.now, dat)
    end

    def conf(key)
      if !hb_bot
        false
      else
        hb_bot[key]
      end
    end

    def navi_buts
      [
          [
              "#{icon('large_orange_diamond')} Send",

          ],
          [
              "#{icon('large_orange_diamond')} Buy",
              "#{icon('large_orange_diamond')} Sell",
          ],
          [
              "#{icon('books')} Home",
              "#{icon('art')} Settings"
          ]
      ]
    end

    def all_transactions(txns)
      lines = ""
      txns.each do |b|
        lines << "#{human_date_short(b.date)} *#{b.amount.to_zld}ZLD* `#{b.bnf}` #{b.details}\n"
      end
      lines
    end

    def settings_buttons
      [
          [
              "#{icon('books')} Statement",
              "#{icon('lock')} RSA keypair"
          ],
          [
              "#{icon('globe_with_meridians')} Language",
              "#{icon('dollar')} Fiat currency",
          ],
          [
              "#{icon('back')} Home",
          ]
      ]
    end


    def btn_cancel_later
      [["#{icon('no_entry')} Cancel", "#{icon('wheelchair')} Later"]]
    end

    def btn_cancel
      "#{icon('no_entry')} Cancel"
    end

    def button(text, action, pay = nil)
      {text: text, callback_data: action, pay: pay}
    end

    def share_button(text, message)
      {text: text, switch_inline_query: message}
    end

    def keyboard(list, slice = 3)
      buts = []
      list.each_slice(slice) do |slice|
        row = []
        slice.each do |res|
          begin
            line = yield res
            row << line
          rescue => eed
            puts "FALSE CLASS"
            puts eed.message
          end
        end
        buts << row
      end
      buts
    end

    def button_value(text, action)
      Hash.new({text: text, value: action})
    end


    def hb_client
      cl = Client.find(tele: "#{chat}")
      if cl.nil?
        begin
          cl = Client.create(tele: "#{chat}", username: "#{from}")
          cl
        rescue
          false
        end
      else
        cl
      end
    end

    def gsess(key)
      session["#{key}"]
    end

    def ssess(key, value)
      session["#{key}"] = value
    end

    def cnt_bold(c)
      "#{c}"
    end

    def ludey(cnt)
      "#{cnt_bold(cnt)} #{Russian.p(cnt, "человек", "человека", "людей")}"
    end

    def otzivov(cnt)
      "#{cnt_bold(cnt)} #{Russian.p(cnt, "отзыв", "отзыва", "отзывов")}"
    end

    def dney(cnt)
      "#{cnt_bold(cnt)} #{Russian.p(cnt, "день", "дня", "дней")}"
    end

    def balance
      "*#{hb_client.balance}* `#{hb_client.currency}`"
    end

    def usd(amount)
      "*#{amount.to_i.round(2)}* `USD`"
    end

  end
end