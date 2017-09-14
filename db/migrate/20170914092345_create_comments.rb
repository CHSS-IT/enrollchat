class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :section, foreign_key: true
      t.text :body
      t.string :ancestry
      t.integer :ancestry_depth, default: 0

      t.timestamps
    end
  end
end
