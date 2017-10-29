class Comment < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :section, required: true

  scope :recent, -> { order(created_at: :desc).limit(5) }
end
