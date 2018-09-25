class RemoveFkConstraints < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :comments, :sections
    remove_foreign_key :comments, :users
  end
end
