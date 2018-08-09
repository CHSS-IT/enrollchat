class AddSectionResolvedToSections < ActiveRecord::Migration[5.2]
  def change
    add_column :sections, :resolved_section, :boolean, default: false
  end
end
