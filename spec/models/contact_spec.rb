require 'rails_helper'
require 'spec_helper'
require 'vcr_helper'

RSpec.describe Contact, type: :model, vcr: VCR_OPTS do
  subject(:contact) { FactoryBot.create :api_contact }
  it { is_expected.to be_valid }

  context 'with contact' do
    it 'creates contact' do
      expect(Contact.count).not_to be_an_zero
    end
  end

  it 'updates pardot mailing lists' do
    contact = create_contact(salesforce_id: '0036f00003HhsOlAAJ')
    subscriptions = contact.list_subscriptions

    expect(subscriptions).to be_an_instance_of(Array)
  end
end
