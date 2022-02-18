require 'rails_helper'

Sidekiq::Testing.inline!

RSpec.describe SyncSalesforceSchoolsJob, type: :job, vcr: VCR_OPTS do
  before(:all) do
    VCR.use_cassette('SyncSalesforceSchoolsJob/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :schools }
  it { is_expected.to be_retryable true }

  it 'syncs schools' do
    SyncSalesforceSchoolsJob.new.perform()
    expect(School.count).to be > 0
  end
end
