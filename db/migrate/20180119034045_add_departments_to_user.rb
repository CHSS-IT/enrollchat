class AddDepartmentsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :departments, :text, array: true, :default => []
  end
end
