require 'rails_helper'
Sidekiq::Testing.inline!

RSpec.describe SyncPardotProspectsAndSubscriptionsJob, type: :job do
  it { is_expected.to be_processed_in :large_jobs }
  it { is_expected.to be_retryable 2 }
end
