class AddChangesToSections < ActiveRecord::Migration[5.2]
  def change
    add_column :sections, :enrollment_limit_yesterday, :integer, limit: 2, default: 0, null: false
    add_column :sections, :actual_enrollment_yesterday, :integer, limit: 2, default: 0, null: false
    add_column :sections, :cross_list_enrollment_yesterday, :integer, limit: 2, default: 0, null: false
    add_column :sections, :waitlist_yesterday, :integer, limit: 2, default: 0, null: false
  end
end
