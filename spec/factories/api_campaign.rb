require 'faker'

FactoryBot.define do
  factory :api_campaign, class: Campaign do
    salesforce_id {Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
    name {Faker::Company.name}
    is_active { [false, true].sample }

  end
end

