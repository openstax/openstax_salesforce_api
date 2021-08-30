require 'rails_helper'
require 'vcr_helper'
Sidekiq::Testing.inline!

RSpec.describe PushOpportunityToSalesforceJob, type: :job, vcr: VCR_OPTS do
  before(:all) do
    @opportunity = FactoryBot.create :api_opportunity
    @new_opportunity = FactoryBot.create :api_new_opportunity
    # create books for test
    FactoryBot.create(:api_book, { name: 'Managerial Accounting', salesforce_id: 'a0Z4C000002JXWSUA4' })
    FactoryBot.create(:api_book, { name: 'Prealgebra', salesforce_id: 'a0Z4C000002JRFOUA4' })
    VCR.use_cassette('PushOpportunityToSalesforceJob/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable true }

  it 'pushes an existing opportunity' do
    PushOpportunityToSalesforceJob.new.perform(@opportunity)
    expect(@opportunity.salesforce_id).to_not be_nil
    expect(@opportunity.lead_source).to eq('Web')
  end

  it 'pushes a new opportunity' do
    PushOpportunityToSalesforceJob.new.perform(@new_opportunity)
    expect(@opportunity.salesforce_id).to_not be_nil
    expect(@opportunity.lead_source).to eq('Web')
  end
end
