require 'faker'

FactoryBot.define do
  factory :api_account_contact_relation, class: AccountContactRelation do
    contact_id { FactoryBot.create(:api_contact).salesforce_id }
    school_id { FactoryBot.create(:api_school).salesforce_id }
  end
end
