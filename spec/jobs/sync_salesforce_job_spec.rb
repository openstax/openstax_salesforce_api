require 'rails_helper'
#require 'vcr_helper'
Sidekiq::Testing.inline!

RSpec.describe SyncSalesforceJob, type: :job do
  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable 1 }

  it 'syncs books' do
    SyncSalesforceJob.new.perform(['Book'])

    expect(Book.count).to be > 1
  end
end
