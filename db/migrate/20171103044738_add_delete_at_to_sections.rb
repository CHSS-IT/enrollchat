class AddDeleteAtToSections < ActiveRecord::Migration[5.1]
  def change
    add_column :sections, :delete_at, :datetime
  end
end
