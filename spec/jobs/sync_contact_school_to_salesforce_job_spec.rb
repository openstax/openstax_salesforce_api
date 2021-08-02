require 'rails_helper'

RSpec.describe SyncContactSchoolsToSalesforceJob, type: :job do
  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable true }
end
