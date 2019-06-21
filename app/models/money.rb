require 'sibit'

class Root

  def self.btc_rate
    sibit = Sibit.new
    sibit.create(Client.__root.btc_pkey)
    sibit.price
  end

end