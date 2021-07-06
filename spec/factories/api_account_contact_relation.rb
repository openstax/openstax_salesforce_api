require 'faker'

FactoryBot.define do
  factory :api_account_contact_relation, class: AccountContactRelation do
	  contact_id {Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
	  school_id {Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
  end
end
