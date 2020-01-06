class User < ApplicationRecord

  enum status: { active: 0, archived: 1 }

  has_many :comments, -> { order 'created_at DESC' }

  scope :in_department, ->(department) { where('? = ANY(departments) OR admin is TRUE', department) }

  scope :wanting_digest, -> { where("email_preference in ('Daily Digest','Comments and Digest') or email_preference is null") }
  scope :wanting_comment_emails, -> { where("email_preference in ('All Comments','Comments and Digest')") }
  scope :wanting_report, -> { where(no_weekly_report: false) }

  before_validation do |model|
    model.departments.reject!(&:blank?) if model.departments
  end

  validates :first_name, :last_name, :username, :email, :status, presence: true
  validates :email, :username, uniqueness: true

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

  def update_login_stats!(request)
    return if new_record?
    old_current = self.current_sign_in_at
    new_current = Time.now.utc
    self.last_sign_in_at = old_current || new_current
    self.current_sign_in_at = new_current

    self.sign_in_count += 1

    old_ip = self.current_sign_in_ip
    new_ip = request.remote_ip
    self.last_sign_in_ip = old_ip || new_ip
    self.current_sign_in_ip = new_ip

    self.active_session = true

    self.save!(touch: false)
  end
end
