class AddUsernameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :username, :string
    User.all.each do |user|
      user.update_attribute(:username, user.email.split('@')[0])
    end
    change_column_null :users, :username, false
    add_index :users, :username, unique: true
  end
end
