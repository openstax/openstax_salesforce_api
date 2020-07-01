# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

50.times do
  schools = School.create(name: Faker::University.name,
                          salesforce_id: Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3),
                          school_type: 'College/University (4)',
                          location: Faker::Address.full_address,
                          is_kip: Faker::Boolean.boolean(true_ratio: 0.2),
                          is_child_of_kip: false)
end