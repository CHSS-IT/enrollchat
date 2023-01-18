class AddDocumentationUrlToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :documentation_url, :string
  end
end
