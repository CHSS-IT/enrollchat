class CreateEnrollments < ActiveRecord::Migration[5.2]
  def change
    create_table :enrollments do |t|
      t.references :section
      t.string :department
      t.integer :term
      t.integer :enrollment_limit, default: 0
      t.integer :actual_enrollment, default: 0
      t.integer :cross_list_enrollment, default: 0
      t.integer :waitlist, default: 0
      t.timestamps
    end
  end
end
