require 'rails_helper'
require 'vcr_helper'
Sidekiq::Testing.inline!

RSpec.describe PushLeadToSalesforceJob, type: :job, vcr: VCR_OPTS do
  before(:all) do
    @lead = FactoryBot.create :api_lead
    VCR.use_cassette('PushLeadToSalesforceJob/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable true }

  it 'pushes a lead' do
    PushLeadToSalesforceJob.new.perform(@lead)
    expect(@lead.salesforce_id).to_not be_nil
    expect(@lead.website).to include('example.com')
  end
end
