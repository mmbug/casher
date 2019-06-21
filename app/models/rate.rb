class Ad < Sequel::Model(:ad)

  def meths
    str = ''
    self.meth.split(",").each do |m|
      str << Meth[m].title << ', '
    end
    str[0...-2]
  end

  def make_link
    encoded = Base64.encode64("#{self.id}")
    "https://t.me/#{BOT_NICKNAME}?start=ad_#{encoded}"
  end


end