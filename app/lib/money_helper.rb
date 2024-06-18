module MoneyHelper
  def transfer_format_money(price)
    return (price.to_s(:delimited))
  end

  
end
