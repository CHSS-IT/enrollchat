class AddMeetingDataToSections < ActiveRecord::Migration[7.0]
  def change
    add_column :sections, :days, :string
    add_column :sections, :start_time, :string
    add_column :sections, :end_time, :string
    add_column :sections, :campus_code, :string
  end
end
