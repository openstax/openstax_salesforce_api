require 'rails_helper'
require 'retry_failed_opportunities'
require 'vcr_helper'

RSpec.describe RetryFailedOpportunities, type: :routine, vcr: VCR_OPTS do
  before(:all) do
    VCR.use_cassette('RetryFailedOpportunities/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  it 'retry opportunity' do
    testOpp = FactoryBot.create_list('opportunity', 1)
    testOpp.salesforce_updated = false
    testOpp.save
    RetryFailedOpportunities.call
  end
end
