require 'faker'

FactoryBot.define do
  factory :account_contact_relation, class: AccountContactRelation do
    contact_id { FactoryBot.create(:contact).salesforce_id }
    school_id { FactoryBot.create(:school).salesforce_id }
  end
end
