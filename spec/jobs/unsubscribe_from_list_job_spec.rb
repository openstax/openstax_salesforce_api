require 'rails_helper'

Sidekiq::Testing.inline!

RSpec.describe UnsubscribeFromListJob, type: :job do
  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :pardot }
  it { is_expected.to be_retryable true }

  it 'subscription status is updated by job' do
    # subscription = Subscription.create(list: @valid_list, contact: @valid_contact)
    # UnsubscribeFromListJob.new.perform(subscription)
    # expect(Subscription.where(list: @valid_list, contact: @valid_contact).exists?).to eq(false)
    pending('Need to implement')
    raise "Not Implemented"
  end

  it 'raises an error with an invalid salesforce id' do
    # expect { UnsubscribeFromListJob.new.perform(@invalid_subscription) }.to raise_error(CannotFindProspect)
    pending('Need to implement')
    raise "Not Implemented"
  end
end
