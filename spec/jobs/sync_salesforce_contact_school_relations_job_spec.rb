require 'rails_helper'

Sidekiq::Testing.inline!

RSpec.describe SyncSalesforceContactSchoolRelationsJob, type: :job, vcr: VCR_OPTS do
  before(:all) do
    VCR.use_cassette('SyncSalesforceContactSchoolRelationsJob/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :schools }
  it { is_expected.to be_retryable true }

  it 'syncs contact school relations' do
    SyncSalesforceContactSchoolRelationsJob.new.perform()
    expect(AccountContactRelation.count).to be > 1
  end
end
