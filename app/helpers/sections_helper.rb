module SectionsHelper
  def term_in_words(term)
    year = term.to_s[0..3]
    term = term.to_s[4..5]
    case term
    when '10'
      then "Spring #{year}"
    when '40'
      then "Summer #{year}"
    when '70'
      then "Fall #{year}"
    end
  end

  def flagged_icon(section)
    if section.flagged_as.present?
      icon_class =     case section.flagged_as
                       when "canceled"
                         'fa fa-ban'
                       when "long-waitlist"
                         'fa fa-list-ol'
                       when "under-enrolled"
                         'fa fa-level-down'
                       end
      text = tag.i(class: icon_class, title: section.flagged_as.capitalize, alt: section.flagged_as.capitalize) #+ section.flagged_as.capitalize
    end
    return text.html_safe if text.present?
  end

  def yesterday_arrow(section, field)
    yesterday = section.show_yesterday(field)
    unless yesterday == 0
      return arrow(yesterday)
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
      return text.html_safe if text.present?
    end
  end

  def level_label(level)
    Section.level_list[Section.level_code_list.find_index(level.downcase)][0]
  end

end
