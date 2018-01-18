class AddEmailPreferenceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :email_preference, :string
  end
end
