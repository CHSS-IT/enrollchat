class AddCanceledAtToSections < ActiveRecord::Migration[5.1]
  def change
    add_column :sections, :canceled_at, :datetime
  end
end
