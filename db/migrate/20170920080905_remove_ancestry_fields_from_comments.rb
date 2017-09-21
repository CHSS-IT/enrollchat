class RemoveAncestryFieldsFromComments < ActiveRecord::Migration[5.1]
  def change
    remove_column :comments, :ancestry, :string
    remove_column :comments, :ancestry_depth, :integer
  end
end
