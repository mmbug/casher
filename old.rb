require 'openssl'
require 'colorize'

module Zold
  module Commands
    module Registration

      def start
        if !hb_client
          start_registration
        else
          reply_simple 'welcome'
        end
      end

      def create_wallet
        wts = Zold::WTS.new("#{ROOT}/id_rsa")
        puts wts.inspect
        puts wts
        hb_client.wallet = wts
        hb_client.save
        reply_message("Your Zold wallet: **#{wts}**", hb_client, nil)
        # Thread.new {
        #   begin
        #     hb_client.create_or_find
        #     reply_simple 'wallet', who: hb_client, cli: hb_client, wal: hb_client.wallet, balance: hb_client.get_balance.to_zld
        #   rescue => e
        #     reply_message "#{icon('no_entry')} #{e.message}. Read /help for more info.", hb_client, navi_buts
        #     payment_cancel
        #     start(false)
        #   end
        # }
      end

      def payment_wallet
        handle('payment_amount')
        reply_message "#{icon('outbox_tray')} Enter *Zold wallet* where you want to *transfer your ZLD* to. Destination wallet should look similar to `07851f5116abbf15`. Read /help for more info.", hb_client, btn_cancel
      end

      def payment_amount(data)
        begin
          matched = data.match(/^[a-f0-9]{16}\z/)
          raise 'Wallet format error' if matched.nil?
          handle('process_payment')
          sset('payment_wallet', data)
          reply_message "You are going to send ZLD to `#{data}`. Enter amount in *ZLD*,  it should look similar to `20.1`, `71` or just `0.53`. Read /help for more info.", hb_client, btn_cancel
          Thread.new {
            hb_client.pull(data)
          }
        rescue => e
          reply_message "#{icon('no_entry')} *Wrong wallet format.* ___Error occured: #{e.message}___. Read /help for more info.", hb_client, navi_buts
          handle('payment_amount')
        end
      end

      def edit_settings
        reply_simple "settings", who: hb_client
      end

      def payment_cancel
        sdel('payment_wallet')
        reply_message "#{icon('no_entry')} You just canceled this payment. Funds will not be transfered anywhere. Read /help for more info.", hb_client, navi_buts
      end

      def cancel
        sdel('payment_wallet')
        sdel('zold_trade')
        sdel('zold_amount')
        sdel('zold_method')
        unhandle
        reply_message "All recent operations canceled. Read /help for more info.", hb_client, navi_buts
      end

      def later
        unhandle
        check_balance
      end

      def process_payment(data)
        wallet = sget('payment_wallet')
        notify("`zold pay`", "Transferring *#{data}ZLD* to wallet `#{wallet}`. *Attention!* This payment cannot be rolled back. Read /help for more info.")
        Thread.new {
          begin
            hb_client.pay(wallet, data, 'for services')
            hb_client.push(wallet)
            reply_message "#{icon('white_check_mark')} Your payment *#{data}ZLD* to *#{wallet}* successfully sent. Read /help for more info.", hb_client, navi_buts
          rescue => e
            reply_message "#{icon('no_entry')} #{e.message}. Read /help for more info.", hb_client, navi_buts
            handle('process_payment')
          end
        }
      end

      def check_balance
        notify("`zold pull`", "This may take a couple of minutes. You will receive notification right away. Read /help for more info.")
        Thread.new {
          hb_client.pull(hb_client.wallet)
          rems = hb_client.remotes
          reply_simple 'wallet', who: hb_client, cli: hb_client, wal: @wallet, balance: hb_client.get_balance.to_zld, remotes: rems
        }
      end

      def deposit_fiat
        reply_message 'Deposit fiat money to Zold wallet'
      end

      def create_buying_trade(data = nil)
        if data.nil?
          handle('create_buying_trade')
          reply_simple 'method', who: nil
        else
          handle('trade_amount')
          puts data
          sset('zold_method', Meth.find(russian: data))
          puts sget('zold_method').inspect
          reply_update 'method', who: nil
          # delete_message(has_editable?)
          trade_amount
        end
      end

      def trade_amount(data = nil)
        if data.nil?
          reply_simple 'amount', who: nil, btns: btn_cancel
        else
          sset('zold_amount', Zold::Amount.new(zld: data.to_f))
          puts sget('zold_method').inspect
          handle(sget('zold_method').title)
          send(sget('zold_method').title.downcase, nil)
        end
      end

      def p2p(data = nil)
        if data.nil?
          handle('p2p')
          reply_inline 'offers', who: nil
        else
          offer =  Offer[data.to_i]
          puts offer.inspect
          tr = Trade.create(
              seller: offer.client,
              buyer: hb_client.id,
              amount: sget('zold_amount').to_i,
              commission: 10,
              meth: sget('zold_method').id,
              offer: offer.id,
              status: Trade::PENDING
          )
          sset('zold_trade', tr)
          delete_message(has_editable?)
          reply_simple 'trade', who: nil, trade: tr, offer: offer
        end
      end

      def confirm_payment
        confirm = true
        if confirm
          reply_message "#{icon('white_check_mark')} Your payment *successfuly* sent to seller. You will receive your *ZLD* in a few minutes. Read /payments for more info or contact support for help..", hb_client, navi_buts
        end
      end

      def card(data = nil)
        send_inv(50)
      end

      def tokenbar(data = nil)
        if data.nil?
          handle('tokenbar')
          reply_message "Enter *TokenBar* activation code. You can find it in your SMS message. Contact TokenBar.net customer support for more info.", nil
        else
          check_tbr = true
          if check_tbr
            reply_message "#{icon('white_check_mark')} You have *successfuly* purchased *#{sget('zold_amount').to_zld} ZLD*. Check your balance. Read /payments for more info or contact support for help..", nil, navi_buts
          else
            reply_message "#{icon('no_entry')} Wrong *TokenBar* code. Check your code and try again. Read /payments for more info or contact support for help.", nil
          end
        end
      end

      def statement
        transactions = hb_client.transactions
        reply_simple 'statement', who: nil, transactions: transactions
      end

      def keypair
        reply_
      end

    end
  end
end
