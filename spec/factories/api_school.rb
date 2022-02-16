require 'faker'

FactoryBot.define do
  factory :api_school, class: School, aliases: [:school] do
    salesforce_id { Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3) }
    name { Faker::University.name }
    city { Faker::Address.city }
    state { Faker::Address.state }
    country { Faker::Address.country }
    school_type { ['High School','College/University (4)', 'K-12 School', 'Technical/Community College (2)', 'Career School/For-Profit (2)'].sample }
    location { %w[Domestic Foreign].sample }
    is_kip { Faker::Boolean }
    is_child_of_kip { Faker::Boolean }
    total_school_enrollment { Faker::Number.between(from:0, to:5000)}
  end
end
