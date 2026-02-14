class Enrollment < ApplicationRecord
  belongs_to :section

  before_save :null_to_zero

  scope :in_term, ->(term) { where(term:) }
  scope :in_department, ->(department) { where(department:) }
  scope :not_canceled, -> { joins(:section).where("status <> 'C'") }
  scope :print_schedule, -> { joins(:section).where(sections: { print_flag: 'Y' }) }
  scope :no_print, -> { joins(:section).where(sections: { print_flag: 'N' }) }

  private

  def null_to_zero
    waitlist = 0 if waitlist.nil?
  end
end
