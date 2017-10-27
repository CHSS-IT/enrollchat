module SectionsHelper
  def term_in_words(term)
    year = term.to_s[0..3]
    term = term.to_s[4..5]
    case term
      when '10'
        then "Spring #{year}"
      when '30'
        then "Summer #{year}"
      when '70'
        then "Fall #{year}"
    end
  end


  def flagged_icon(section)
    if section.flagged_as.present?
      icon_class =     case section.flagged_as
                         when "canceled"
                           'fa fa-ban fa-pull-left'
                         when "waitlisted"
                           'fa fa-list-ol fa-pull-left'
                         when "under-enrolled"
                           'fa fa-level-down fa-pull-left'
                       end
      text = tag.i({class: icon_class, title: section.flagged_as.capitalize, alt: section.flagged_as.capitalize}) + section.flagged_as.capitalize
    end
    return text.html_safe if text.present?
  end

end
