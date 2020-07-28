require 'faker'

FactoryBot.define do
  factory :campaign, class: OpenStax::Salesforce::Remote::Campaign do
    skip_create
    id {Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
    name {Faker::Company.name}
    is_active { [false, true].sample }

  end
end

