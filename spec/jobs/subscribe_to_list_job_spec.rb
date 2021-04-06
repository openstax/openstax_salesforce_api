require 'rails_helper'
require 'vcr_helper'

Sidekiq::Testing.inline!

RSpec.describe SubscribeToListJob, type: :job, vcr: VCR_OPTS do
  before(:all) do
    @valid_list = FactoryBot.create :list, pardot_id: 5355
    @valid_contact = create_contact(salesforce_id: '0030v00000UlS9yAAF')

    @invalid_prospect_list = FactoryBot.create :list, pardot_id: 0
    @invalid_prospect_contact = create_contact(salesforce_id: '0030v00000XxX0xXXX')
    @invalid_subscription = FactoryBot.create :subscription, contact: @invalid_prospect_contact, list: @invalid_prospect_list
  end

  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable 5 }

  it 'subscription status is updated by job' do
    subscription = Subscription.create(list: @valid_list, contact: @valid_contact)
    SubscribeToListJob.new.perform(subscription)
    expect(subscription.created?).to eq(true)
  end

  it 'raises an error with an invalid salesforce id' do
    expect { SubscribeToListJob.new.perform(@invalid_subscription) }.to raise_error(CannotFindProspect)
  end

  it 'creates the subscription in Pardot' do
    subscription = Subscription.create(list: @valid_list, contact: @valid_contact)
    SubscribeToListJob.new.perform(subscription)

    prospect = Pardot.client.prospects.read_by_fid(subscription.contact.salesforce_id)
    expect(prospect['lists']['list_subscription']).to include(a_hash_including('list'))
  end
end
