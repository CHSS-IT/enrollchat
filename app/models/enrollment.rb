class Enrollment < ApplicationRecord
  belongs_to :section

  before_save :null_to_zero

  private

  def null_to_zero
    waitlist = waitlist.nil? ? 0 : waitlist
  end
end
