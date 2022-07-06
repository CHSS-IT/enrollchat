class AddDataFeedUriToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :data_feed_uri, :string
  end
end
