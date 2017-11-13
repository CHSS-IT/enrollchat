class Comment < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :section, required: true

  default_scope { joins(:section).where("sections.delete_at is null") }

  # Behavior is a tad arbitrary. Most recent five comments.
  scope :recent, -> { order(created_at: :desc).limit(5) }

  def noticed?(current_user)
    created_at < current_user.last_activity_check
  end

end
