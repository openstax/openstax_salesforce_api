require 'faker'

FactoryBot.define do
  factory :list, class: List do
    pardot_id { '6391' }
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentences(number: 1) }
  end
end
