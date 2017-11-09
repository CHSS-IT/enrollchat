class Comment < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :section, required: true

  scope :recent, -> { joins(:section).where("sections.delete_at is null").order(created_at: :desc).limit(5) }

end
