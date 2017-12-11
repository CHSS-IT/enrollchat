class ChangeSectionNumberToString < ActiveRecord::Migration[5.1]
  def change
    change_column :sections, :section_number, :string
  end
end
