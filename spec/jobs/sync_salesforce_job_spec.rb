require 'rails_helper'
require 'vcr_helper'
Sidekiq::Testing.inline!

RSpec.describe SyncSalesforceJob, type: :job, vcr: VCR_OPTS do
  before(:each) do
    Sidekiq::Worker.clear_all
  end

  before(:all) do
    VCR.use_cassette('SyncSalesforceJob/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable true }

  it 'syncs the book salesforce data' do
    SyncSalesforceJob.new.perform ['Book']
    expect(Book.count).to be > 1
  end

  it 'syncs the Leads salesforce data' do
    SyncSalesforceJob.new.perform ['Lead']
    expect(Lead.count).to be > 1
  end

  it 'syncs the School salesforce data' do
    SyncSalesforceJob.new.perform ['School']
    expect(School.count).to be > 1
  end

  it 'syncs all salesforce data' do
    SyncSalesforceJob.new.perform
    expect(Book.count).to be > 1
    expect(Lead.count).to be > 1
    expect(School.count).to be > 1
  end

  it 'handles wrong parameter by doing nothing' do
    SyncSalesforceJob.new.perform(['Junk'])
  end
end
