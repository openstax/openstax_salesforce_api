require 'faker'
FactoryBot.define do
  factory :book, class: Book do
    salesforce_id { Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3) }
    name { Faker::Book.title }
  end
end
