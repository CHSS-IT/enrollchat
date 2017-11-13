class AddLastActivityCheckToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_activity_check, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
