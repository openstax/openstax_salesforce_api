require 'rails_helper'
require 'vcr_helper'
Sidekiq::Testing.inline!

RSpec.describe SyncSalesforceContactSchoolRelationsJob, type: :job, vcr: VCR_OPTS do
  before(:each) do
    Sidekiq::Worker.clear_all
  end

  before(:all) do
    VCR.use_cassette('SyncSalesforceContactSchoolRelationsJob/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable true }

  it 'syncs contact school relations' do
    SyncSalesforceContactSchoolRelationsJob.new.perform()

    expect(AccountContactRelation.count).to be > 1
  end

  it 'syncs one contact school relation' do
    SyncSalesforceContactSchoolRelationsJob.new.perform('07k4C00000HKmw1QAD')

    expect(AccountContactRelation.where(salesforce_id: '07k4C00000HKmw1QAD')).to exist
  end
end
