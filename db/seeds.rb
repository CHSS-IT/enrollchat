# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# require 'csv'
#
# CSV.foreach(Rails.root.join('lib', 'seeds', 'sections.csv'), :headers => true) do |row|
#     Section.create!(row.to_hash)
# end

# Users
admin = User.create!(email: 'sdaviso@gmu.edu', username: 'sdaviso', first_name: 'Shannon', last_name: 'Davis', admin: true)
admin = User.create!(email: 'rmatz@gmu.edu', username: 'rmatz', first_name: 'Robert', last_name: 'Matz', admin: true)
admin = User.create!(email: 'dcollie2@gmu.edu', username: 'dcollie2', first_name: 'Daniel', last_name: 'Collier', admin: true)
admin = User.create!(email: 'czaccaro@gmu.edu', username: 'czaccaro', first_name: 'Craig', last_name: 'Zaccaro', admin: true)
admin = User.create!(email: 'mwhiteo@gmu.edu', username: 'mwhiteo', first_name: 'Melanie', last_name: 'White', admin: true)
user = User.create!(email: 'chssweb@gmu.edu', username: 'chssweb', first_name: 'Limited', last_name: 'User', admin: false)

user = User.create!(email: 'kthomps4@gmu.edu', username: 'kthomps4', first_name: 'Ken', last_name: 'Thompson')
user = User.create!(email: 'dwilsonb@gmu.edu', username: 'dwilsonb', first_name: 'David', last_name: 'Wilson')
user = User.create!(email: 'dnewmark@gmu.edu', username: 'dnewmark', first_name: 'Lisa', last_name: 'Newmark')
user = User.create!(email: 'anicoter@gmu.edu', username: 'anicoter', first_name: 'Anne', last_name: 'Nicotera')
user = User.create!(email: 'eeisner@gmu.edu', username: 'eeisner', first_name: 'Eric', last_name: 'Eisner')
user = User.create!(email: 'dhouser@gmu.edu', username: 'dhouser', first_name: 'Dan', last_name: 'Houser')
user = User.create!(email: 'jdunick@gmu.edu', username: 'jdunick', first_name: 'Jason', last_name: 'Dunick')
user = User.create!(email: 'lbreglia@gmu.edu', username: 'lbreglia', first_name: 'Lisa', last_name: 'Breglia')
user = User.create!(email: 'jarminio@gmu.edu', username: 'jarminio', first_name: 'Jan', last_name: 'Arminio')
user = User.create!(email: 'rberroa@gmu.edu', username: 'rberroa', first_name: 'Rei', last_name: 'Berroa')
user = User.create!(email: 'sridley@gmu.edu', username: 'sridley', first_name: 'Susan', last_name: 'Ridley')
user = User.create!(email: 'asachedi@gmu.edu', username: 'asachedi', first_name: 'Abdulaziz', last_name: 'Sachedina')
user = User.create!(email: 'rjones23@gmu.edu', username: 'rjones23', first_name: 'Rachel', last_name: 'Jones')
user = User.create!(email: 'abest@gmu.edu', username: 'abest', first_name: 'Amy', last_name: 'Best')
