class AddDefaultsToNumerical < ActiveRecord::Migration[5.1]
  def change
    change_column :sections, :enrollment_limit, :integer, default: 0
    change_column :sections, :actual_enrollment, :integer, default: 0
    change_column :sections, :cross_list_enrollment, :integer, default: 0
    change_column :sections, :waitlist, :integer, default: 0
  end
end
