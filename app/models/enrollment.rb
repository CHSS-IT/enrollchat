class Enrollment < ApplicationRecord
  belongs_to :section

  before_save :null_to_zero

  scope :in_term, ->(term) { where(term: term) }
  scope :in_department, ->(department) { where(department: department) }
  scope :not_canceled, -> { joins(:section).where("status <> 'C'") }

  private

  def null_to_zero
    waitlist = 0 if waitlist.nil?
  end
end
