module ApplicationHelper

  def basic_date(date)
    date.strftime('%B %-d, %Y')
  end

  def basic_datetime(date)
    date.strftime('%B %-d at %l:%M %P')
  end
end
