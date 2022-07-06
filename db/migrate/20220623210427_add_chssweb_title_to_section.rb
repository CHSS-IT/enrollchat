class AddChsswebTitleToSection < ActiveRecord::Migration[7.0]
  def change
    add_column :sections, :chssweb_title, :string
    add_column :sections, :description_present, :boolean
    add_column :sections, :syllabus_present, :boolean
    add_column :sections, :image_present, :boolean
    add_column :sections, :youtube_present, :boolean
  end
end
