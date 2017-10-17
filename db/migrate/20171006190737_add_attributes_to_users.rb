class AddAttributesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :first_name, :string, limit: 255, null: false
    add_column :users, :last_name, :string, limit: 255, null: false
  end
end
