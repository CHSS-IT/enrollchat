module ApplicationHelper

  def basic_date(date)
    date.strftime('%B %-d, %Y')
  end

  def basic_datetime(date)
    date.strftime('%B %-d at %l:%M %P')
  end

  def comment_alert_time(date)
    if date.day == Date.today.day
      "at #{date.strftime('%l:%M %P')}"
    else
      "on #{date.strftime('%B %-d at %l:%M %P')}"
    end
  end
end
