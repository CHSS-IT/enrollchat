module DeliveryWindows
  def delivery_window
    now = Time.zone.now
    fall_reg_window = now.month.between?(ENV['TERM_ONE_START'].to_i, ENV['TERM_ONE_END'].to_i)
    spring_reg_window = now.month >= ENV['TERM_TWO_START'].to_i || now.month <= ENV['TERM_TWO_END'].to_i
    if fall_reg_window || spring_reg_window
      true
    else
      false
    end
  end
end
