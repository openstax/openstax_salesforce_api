require 'rails_helper'

Sidekiq::Testing.inline!

RSpec.describe SyncSalesforceContactsJob, type: :job, vcr: VCR_OPTS do
  before(:all) do
    VCR.use_cassette('SyncSalesforceContactsJob/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :contacts }
  it { is_expected.to be_retryable true }

  it 'syncs contacts' do
    SyncSalesforceContactsJob.new.perform()
    expect(Contact.count).to be > 0
  end
end
