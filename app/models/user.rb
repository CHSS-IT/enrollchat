class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable, :trackable

  enum status: [:active, :archived]

  has_many :comments, -> { order 'created_at DESC'}

  scope :in_department, ->(department) { where('? = ANY(departments) OR admin is TRUE', department) }

  scope :wanting_digest, -> { where("email_preference in ('Daily Digest','Comments and Digest') or email_preference is null") }
  scope :wanting_comment_emails, -> { where("email_preference in ('All Comments','Comments and Digest')") }
  scope :wanting_report, -> { where(no_weekly_report: false) }

  before_validation do |model|
    model.departments.reject!(&:blank?) if model.departments
  end

  validates_presence_of :first_name, :last_name, :username, :email, :status
  validates_uniqueness_of :email, :username

  def departments_of_interest
    comments.collect { |c| c.section.department }.uniq.sort
  end

  def reporting_departments
    departments.empty? ? Section.all.pluck(:department).uniq.sort : departments
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def is_admin?
    self.admin?
  end

  def checked_activities!
    update_column(:last_activity_check, DateTime.now())
  end

  def self.email_options
    ['All Comments', 'Daily Digest', 'Comments and Digest', 'No Emails']
  end

  def self.status_list
    statuses.keys
  end

  def show_alerts(department)
    departments.include?(department) || is_admin?
  end
end
