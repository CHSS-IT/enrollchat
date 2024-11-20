module SectionsHelper
  def flagged_icon(section)
    if section.flagged_as.present?
      icon_class =     case section.flagged_as
                       when "canceled"
                         'fa fa-ban'
                       when "long-waitlist"
                         'fa fa-list-ol'
                       when "under-enrolled"
                         'fa fa-turn-down'
                       end
      text = tag.i(class: icon_class, title: section.flagged_as.capitalize, alt: section.flagged_as.capitalize) # + section.flagged_as.capitalize
    end
    text.html_safe if text.present?
  end

  def yesterday_arrow(section, field)
    yesterday = section.show_yesterday(field)
    unless yesterday == 0
      arrow(yesterday)
    end
  end

  def arrow(change)
    unless change == 0
      if change.positive?
        direction = 'up'
        color = 'success'
      else
        direction = 'down'
        color = 'danger'
      end
      text = '&nbsp;<span class="badge badge-pill badge-' + color + '">'
      text += content_tag(:i, '', class: "fa fa-arrow-circle-#{direction} fa-inverse") + ' ' + change.to_s
      text += '</span>'
      text.html_safe if text.present?
    end
  end

  def level_label(level)
    if level == 'No Value'
      level
    else
      Section.level_list[Section.level_code_list.find_index(level.downcase)][0]
    end
  end

  def truthiness_indicator(value)
    tag.i class: 'fa-solid fa-circle-check fa-lg fa-xl' if value
  end

  def day_and_time(section)
    "#{section.days} #{section.formatted_time(section.start_time)}-#{section.formatted_time(section.end_time)}"
  end
end
