class AddNoWeeklyReportToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :no_weekly_report, :boolean, default: false, null: false
  end
end
