module ApplicationHelper

  def basic_date(date)
    date.strftime('%B %-d, %Y')
  end
end
