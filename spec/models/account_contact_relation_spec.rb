require 'rails_helper'

RSpec.describe AccountContactRelation, type: :model do
  it "creates relation" do
    relation = FactoryBot.create :account_contact_relation
    expect(relation).to be_valid

    expect(AccountContactRelation.count).not_to be_an_zero
  end
end
