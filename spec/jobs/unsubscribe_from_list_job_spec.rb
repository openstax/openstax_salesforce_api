require 'rails_helper'
require 'vcr_helper'

Sidekiq::Testing.inline!

RSpec.describe UnsubscribeFromListJob, type: :job, vcr: VCR_OPTS do
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
  it { is_expected.to be_retryable true }

  it 'subscription status is updated by job' do
    subscription = Subscription.create(list: @valid_list, contact: @valid_contact)
    UnsubscribeFromListJob.new.perform(subscription)
    expect(Subscription.where(list: @valid_list, contact: @valid_contact).exists?).to eq(false)
  end

  it 'raises an error with an invalid salesforce id' do
    expect { UnsubscribeFromListJob.new.perform(@invalid_subscription) }.to raise_error(CannotFindProspect)
  end
end
