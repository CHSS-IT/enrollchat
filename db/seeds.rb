# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

CSV.foreach(Rails.root.join('lib', 'seeds', 'sections.csv'), :headers => true) do |row|
    Section.create!(row.to_hash)
end

admin = User.create!(email: 'chssweb@gmu.edu', password: 'chss4admins')