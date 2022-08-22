class AddInstructorToSection < ActiveRecord::Migration[7.0]
  def change
    add_column :sections, :instructor_name, :string
    add_column :sections, :second_instructor_name, :string
  end
end
