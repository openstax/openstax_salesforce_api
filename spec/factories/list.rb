require 'faker'

FactoryBot.define do
  factory :list, class: List do
    pardot_id { Faker::Number.leading_zero_number(digits: 4) }
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentences(number: 1) }
  end
end
