require 'rails_helper'
require 'vcr_helper'
Sidekiq::Testing.inline!

RSpec.describe SyncSalesforceJob, type: :job, vcr: VCR_OPTS do
  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable true }

  it 'syncs account contact relation' do
    SyncSalesforceJob.new.perform(['AccountContactRelation'])
    expect(AccountContactRelation.count).to be > 1
  end

  it 'syncs books' do
    SyncSalesforceJob.new.perform(['Book'])
    expect(Book.count).to be > 1
  end

  it 'syncs leads' do
    SyncSalesforceJob.new.perform(['Lead'])
    expect(Lead.count).to be > 1
  end

  it 'syncs opportunities' do
    SyncSalesforceJob.new.perform(['Opportunity'])
    expect(Opportunity.count).to be > 1
  end

  it 'syncs schools' do
    SyncSalesforceJob.new.perform(['School'])
    expect(School.count).to be > 1
  end

  it 'handles wrong parameter by doing nothing' do
    SyncSalesforceJob.new.perform(['Junk'])
  end
end
