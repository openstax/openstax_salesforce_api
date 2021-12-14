require 'rails_helper'
require 'vcr_helper'
Sidekiq::Testing.inline!

RSpec.describe SyncSalesforceOpportunitiesJob, type: :job, vcr: VCR_OPTS do
  before(:each) do
    Sidekiq::Worker.clear_all
  end

  before(:all) do
    VCR.use_cassette('SyncSalesforceOpportunitiesJob/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable true }

  it 'syncs opportunities' do
    SyncSalesforceOpportunitiesJob.new.perform()

    expect(Opportunity.count).to be > 0
  end

  it 'syncs one opportunity' do
    SyncSalesforceOpportunitiesJob.new.perform('5113ab26-ba8d-4fd0-bec1-a4792248a883')

    expect(Opportunity.where(salesforce_id: '0064C00000G8im8QAB')).to exist
  end
end
