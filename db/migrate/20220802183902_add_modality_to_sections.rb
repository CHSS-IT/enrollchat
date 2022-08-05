class AddModalityToSections < ActiveRecord::Migration[7.0]
  def change
    add_column :sections, :modality, :string
    add_column :sections, :modality_description, :string
    add_column :sections, :print_flag, :string
  end
end
