Choose *exchange method* and proceed. All trades are automatic. For more info about exchange methods, read /payments
****
buts = []
@avlbl = Meth.where(status: Meth::ACTIVE)
buts = keyboard(@avlbl, 1) do |m|
  if !sget('zold_method')
    method_icon = icon('currency_exchange')
  else
    if sget('zold_method').title == m.title
      method_icon = icon('currency_exchange')
    else
      method_icon = icon('currency_exchange')
    end
  end
  "#{method_icon} #{m.russian}"
end
buts << [btn_cancel]