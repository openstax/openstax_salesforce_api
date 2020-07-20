require 'faker'

FactoryBot.define do
  factory :school, class: OpenStax::Salesforce::Remote::School do
    skip_create
    name {Faker::University.name}
    id {Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
    type { ['High School','College/University (4)', 'K-12 School', 'Technical/Community College (2)', 'Career School/For-Profit (2)'].sample }
    school_location { ['Domestic','Foreign'].sample }
  end

  trait :is_kip do
    is_kip { true }
  end

  trait :is_child_of_kip do
    is_child_of_kip { true }
  end

end