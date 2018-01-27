class Comment < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :section, required: true

  validates_presence_of :body

  default_scope { joins(:section).where("sections.delete_at is null") }

  # Behavior is a tad arbitrary. Most recent five comments.
  scope :recent, -> { order(created_at: :desc).limit(5) }
  scope :recent_unread, ->(current_user) { where('comments.created_at > ?', current_user.last_activity_check).order(created_at: :desc) }
  scope :yesterday, -> { where('comments.created_at >= ? and comments.created_at <= ?', 1.day.ago.beginning_of_day,  1.day.ago.end_of_day) }
  scope :for_department, ->(department) { includes(:section).where('sections.department = ?', department).order('sections.course_description, comments.created_at') }
  scope :by_course, -> { includes(:section).order('sections.course_description') }#.group(:section)}

  def noticed?(current_user)
    created_at < current_user.last_activity_check
  end

end
