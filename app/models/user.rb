class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable, :trackable

  validates_presence_of :first_name, :last_name, :username, :email

  def full_name
    "#{first_name} #{last_name}"
  end

  def is_admin?
    self.admin?
  end

end
