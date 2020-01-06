class AddActiveSessionToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :active_session, :boolean, default: false
  end
end
