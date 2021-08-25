require 'rails_helper'
#require 'vcr_helper'
Sidekiq::Testing.inline!

RSpec.describe PushLeadToSalesforceJob, type: :job do
  before(:all) do
    @lead = FactoryBot.create :api_lead
  end

  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable true }

  it 'pushes a lead' do
    puts @lead.inspect
    PushLeadToSalesforceJob.new.perform(@lead)
    expect(@lead.salesforce_id).to_not be_nil
    expect(@lead.website).to include('example.com')
  end
end
