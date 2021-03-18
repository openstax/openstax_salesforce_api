require 'rails_helper'
Sidekiq::Testing.inline!

RSpec.describe SubscribeToListJob, type: :job do
  it { is_expected.to be_processed_in :subscriptions }
  it { is_expected.to be_retryable 5 }
end
