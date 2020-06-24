require 'faker'

FactoryBot.define do
  factory :school do
    name {Faker::University.name}
    salesforce_id {Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
    school_type {'College/University (4)'}
    location {Faker::Address.full_address}
  end

  trait :is_kip do
    is_kip { true }
  end

  trait :is_child_of_kip do
    is_child_of_kip { true }
  end

end