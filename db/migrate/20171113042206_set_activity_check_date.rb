class SetActivityCheckDate < ActiveRecord::Migration[5.1]
  def change
    User.update_all(last_activity_check: 3.months.ago)
  end
end
