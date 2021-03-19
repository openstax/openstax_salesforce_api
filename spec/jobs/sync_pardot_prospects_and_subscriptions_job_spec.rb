require 'rails_helper'
require 'vcr_helper'
Sidekiq::Testing.inline!

RSpec.describe SyncPardotProspectsAndSubscriptionsJob, type: :job, vcr: VCR_OPTS do
  before(:all) do
    @multiple_subscriptions_contact = create_contact(salesforce_id: '0030v00000UlS9yAAF')
    @one_subscription_contact = create_contact(salesforce_id: '0030v00000UxsZmAAJ')
    @no_subscription_contact = create_contact(salesforce_id: '0030v00000UjqeIAAR')
    @list = FactoryBot.create :list
  end

  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable 2 }

  it 'creates subscriptions from sync job if someone has more than one subscription' do
    SyncPardotProspectsAndSubscriptionsJob.new.perform(@multiple_subscriptions_contact.salesforce_id)

    expect(Subscription.where(contact: @multiple_subscriptions_contact).count).to be > 1
  end

  it 'creates subscriptions from sync job is someone has only one subscription' do
    SyncPardotProspectsAndSubscriptionsJob.new.perform(@one_subscription_contact.salesforce_id)

    expect(Subscription.where(contact: @one_subscription_contact).count).to be 1
  end

  it 'does not create anything if there are no subscriptions' do
    SyncPardotProspectsAndSubscriptionsJob.new.perform(@no_subscription_contact.salesforce_id)

    expect(Subscription.where(contact: @no_subscription_contact).count).to be 0
  end

  it 'removes stale subscriptions' do
    Subscription.create(contact: @multiple_subscriptions_contact, list: @list)
    SyncPardotProspectsAndSubscriptionsJob.new.perform(@multiple_subscriptions_contact.salesforce_id)

    expect(Subscription.where(contact: @multiple_subscriptions_contact).count).to be 2
  end
end
