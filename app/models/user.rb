class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable, :trackable

  def full_name
    "#{first_name} #{last_name}"
  end

end
