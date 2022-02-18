require 'rails_helper'

Sidekiq::Testing.inline!

RSpec.describe SyncPardotJob, type: :job do
  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :pardot }
  it { is_expected.to be_retryable true }

  it 'creates the lists' do
    # SyncPardotJob.new.perform()
    # expect(List.count).to be > 1
    pending('This probably needs to be done against a Pardot instance to record')
    raise "Not Implemented"
  end

  it 'creates subscriptions from sync job' do
    # SyncPardotJob.new.perform(@contact.salesforce_id)
    # expect(Subscription.where(contact: @contact).count).to be > 1
    pending("This probably needs to be done against a Pardot instance to record")
    raise "Not Implemented"
  end
end
