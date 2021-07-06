require 'rails_helper'

RSpec.describe AccountContactRelation, type: :model do
  subject(:account_contact_relation) { FactoryBot.create :api_account_contact_relation }
  it { is_expected.to be_valid }

  context 'with relation' do
    it 'creates relation' do
      expect(AccountContactRelation.count).not_to be_an_zero
    end
  end
end
