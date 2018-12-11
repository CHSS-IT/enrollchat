class AddThresholdsToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :graduate_enrollment_threshold, :integer, default: 10
    add_column :settings, :undergraduate_enrollment_threshold, :integer, default: 15
  end
end
