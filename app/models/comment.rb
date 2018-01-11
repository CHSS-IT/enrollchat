class Comment < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :section, required: true

  validates_presence_of :body

  default_scope { joins(:section).where("sections.delete_at is null") }

  # Behavior is a tad arbitrary. Most recent five comments.
  scope :recent, -> { order(created_at: :desc).limit(5) }
  scope :recent_unread, ->(current_user) { where('comments.created_at > ?', current_user.last_activity_check).order(created_at: :desc) }

  def noticed?(current_user)
    created_at < current_user.last_activity_check
  end

end
