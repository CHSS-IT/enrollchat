class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.integer :current_term
      t.integer :singleton_guard, default: 0

      t.timestamps
    end
    add_index(:settings, :singleton_guard, :unique => true)
  end
end


