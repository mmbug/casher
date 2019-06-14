require 'sibit'

class Client < Sequel::Model(:client)

  include CRX::Helpers

  def self.__referals
    Client.find(username: '__refs')
  end

  def signed?
    self.signed == 1
  end

  def balance
    sibit = Sibit.new
    address = sibit.create(self.btc_pkey)
    price = sibit.price
    balance = sibit.balance(address)
    satoshi_to_usd(balance, price)
    50
  end

  def btc_rate
    sibit = Sibit.new
    sibit.create(self.btc_pkey)
    sibit.price
  end

  def balance_in_btc
    sibit = Sibit.new
    address = sibit.create(self.btc_pkey)
    price = sibit.price
    balance = sibit.balance(address)
    satoshi_to_btc(balance, price)
  end

  def trade_turnover
    turnover = Trade.where(
        Sequel.&(
            Sequel.or(buyer: self.id, seller: self.id),
            status: Trade::CLOSED
        )
    ).sum(:amount)
    turnover || 0.0
  end

  def master
    referal = Referal.find(referal: self.id)
    if !referal.nil?
      Client[referal.client]
    else
      false
    end
  end

  def referals
    Referal.where(client: self.id)
  end

  def make_referal_link
    encoded = Base64.encode64("#{self.tele}")
    "https://t.me/#{BOT_NICKNAME}?start=#{encoded}"
  end

  def referals_earnings
    credit = Ledger.dataset.
        select{Sequel.as(Sequel.expr{COALESCE(sum(:amount), 0)}, :bns)}.
        where(credit: self.id, debit: Client::__referals.id)
    credit.map(:bns)[0].round(2)
  end

  def available_sellers
    Ad.join(:client, :id => :ad__client).where(status: 1)
  end

end