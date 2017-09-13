class CreateSections < ActiveRecord::Migration[5.1]
  def change
    create_table :sections do |t|
      t.string :owner
      t.integer :term
      t.integer :section_id
      t.string :department
      t.string :cross_list_group
      t.string :course_description
      t.integer :section_number
      t.string :title
      t.integer :credits
      t.string :level
      t.string :status
      t.integer :enrollment_limit
      t.integer :actual_enrollment
      t.integer :cross_list_enrollment
      t.integer :waitlist

      t.timestamps
    end
  end
end
