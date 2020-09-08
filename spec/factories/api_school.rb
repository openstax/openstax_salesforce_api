require 'faker'

FactoryBot.define do
  factory :api_school, class: School do
    name {Faker::University.name}
    salesforce_id {Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
    school_type { ['High School','College/University (4)', 'K-12 School', 'Technical/Community College (2)', 'Career School/For-Profit (2)'].sample }
    location { ['Domestic','Foreign'].sample }
    is_kip {Faker::Boolean}
    is_child_of_kip {Faker::Boolean}
  end
end
