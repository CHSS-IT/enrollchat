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
end
