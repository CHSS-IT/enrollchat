class AddEmailConfigToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :email_delivery, :integer, default: 0
  end
end
