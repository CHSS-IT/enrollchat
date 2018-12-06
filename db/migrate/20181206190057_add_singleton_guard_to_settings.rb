class AddSingletonGuardToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :singleton_guard, :integer, limit: 1
    add_index(:settings, :singleton_guard, :unique => true)
  end
end
