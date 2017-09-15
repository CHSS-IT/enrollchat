class Section < ApplicationRecord

  has_many :comments

  def section_number_zeroed
    section_number.to_s.rjust(3, "0")
  end

  def section_and_number
    "#{course_description}-#{section_number_zeroed}"
  end
end
