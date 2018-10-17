module DeliveryWindows
  def delivery_window
    now = Time.zone.now
    fall_reg_window = now.month > 3 && now.month < 10
    spring_reg_window = now.month > 10 || now.month < 2
    if fall_reg_window
      true
    elsif spring_reg_window
      true
    else
      false
    end
  end
end
