require 'rails_helper'
require 'vcr_helper'
Sidekiq::Testing.inline!

RSpec.describe SyncSalesforceJob, type: :job, vcr: VCR_OPTS do
  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable true }

  it 'syncs the salesforce data' do
    SyncSalesforceJob.new.perform()
    expect(AccountContactRelation.count).to be > 1
    expect(Book.count).to be > 1
    expect(Lead.count).to be > 1
    expect(Opportunity.count).to be > 1
    expect(School.count).to be > 1
  end

  it 'handles wrong parameter by doing nothing' do
    SyncSalesforceJob.new.perform(['Junk'])
  end
end
