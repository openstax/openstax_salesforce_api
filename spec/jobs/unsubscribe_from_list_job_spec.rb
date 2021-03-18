require 'rails_helper'
Sidekiq::Testing.inline!

RSpec.describe UnsubscribeFromListJob, type: :job do
  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable 5 }
end
