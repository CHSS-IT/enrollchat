class Comment < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :section, required: true

  validates_presence_of :body

  default_scope { joins(:section).where("sections.delete_at is null") }

  # Behavior is a tad arbitrary. Most recent five comments.
  scope :recent, -> { order(created_at: :desc).limit(5) }
  scope :in_past_day, -> { where('comments.created_at > ?', 1.day.ago) }
  scope :in_past_week, -> { where('comments.created_at > ?', 1.week.ago) }
  scope :recent_unread, ->(current_user) { where('comments.created_at > ?', current_user.last_activity_check).order(created_at: :desc) }
  scope :yesterday, -> { where('comments.created_at >= ? and comments.created_at <= ?', 1.day.ago.beginning_of_day,  1.day.ago.end_of_day) }
  scope :for_department, ->(department) { includes(:section).where('sections.department = ?', department).order('sections.course_description, comments.created_at') }
  scope :in_term, ->(term) { includes(:section).where('sections.term = ?', term) }
  scope :by_course, -> { includes(:section).order('sections.course_description') }#.group(:section)}
  scope :recent_by_interest, ->(current_user) { where('sections.department in (?)', current_user.departments).order(created_at: :desc) }
  scope :recent_unread_by_interest, ->(current_user) { where('sections.department in (?)', current_user.departments).where('comments.created_at > ?', current_user.last_activity_check).order(created_at: :desc) }
  scope :most_recent, -> { order(created_at: :desc).pluck(:created_at).last }

  def noticed?(current_user)
    created_at < current_user.last_activity_check
  end

end
