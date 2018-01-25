class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable, :trackable
  has_many :comments, -> { order 'created_at DESC'}

  scope :in_department, ->(department) { where('? = ANY(departments) OR admin is TRUE', department) }

  scope :wanting_digest, -> { where("email_preference in ('Daily Digest','Comments and Digest') or email_preference is null") }


  before_validation do |model|
    model.departments.reject!(&:blank?) if model.departments
  end

  validates_presence_of :first_name, :last_name, :username, :email

  def departments_of_interest
    comments.collect { |c| c.section.department }.uniq.sort
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
end
