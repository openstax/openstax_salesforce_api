require 'rails_helper'
require 'vcr_helper'
Sidekiq::Testing.inline!

RSpec.describe SyncPardotJob, type: :job, vcr: VCR_OPTS do
  before(:all) do
    @contact = create_contact(salesforce_id: '0030v00000UlS9yAAF')
    @no_subscription_contact = create_contact(salesforce_id: '0030v00000UjqeIAAR')
  end

  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable 2 }

  it 'creates the lists' do
    SyncPardotJob.new.perform(@contact.salesforce_id)

    expect(List.count).to be > 1
  end

  it 'creates subscriptions from sync job' do
    SyncPardotJob.new.perform(@contact.salesforce_id)

    expect(Subscription.where(contact: @contact).count).to be > 1
  end

  it 'does not create anything if there are no subscriptions' do
    SyncPardotJob.new.perform(@no_subscription_contact.salesforce_id)

    expect(Subscription.where(contact: @no_subscription_contact).count).to be 0
  end
end
