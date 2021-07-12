require 'rails_helper'
require 'vcr_helper'
Sidekiq::Testing.inline!

RSpec.describe PushOpportunityToSalesforceJob, type: :job do
  before(:all) do
    @opportunity = FactoryBot.create :api_opportunity
  end

  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable 5 }

  it 'pushes an opportunity' do
    PushOpportunityToSalesforceJob.new.perform(@opportunity)
    expect(@opportunity.salesforce_id).to_not be_nil
    expect(@opportunity.lead_source).to eq('Web')
  end
end
