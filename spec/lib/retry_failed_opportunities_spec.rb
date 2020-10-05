require 'rails_helper'
require 'retry_failed_opportunities'
require 'vcr_helper'

RSpec.describe RetryFailedOpportunities, type: :routine, vcr: VCR_OPTS do


  before(:all) do
    @book = FactoryBot.create(:api_book, {:salesforce_id=>'a0Z0B00000HPp9ZUAT',:name=>'Fake Book Name'})
    @test_opp = FactoryBot.create(:api_opportunity, {:salesforce_id=>'Not Set',:term_year=>'2019 - 20 Spring',:book_name=>@book.name,:contact_id=>'0037X00000cVyfIQAS',:new=>true,:close_date=>'2020-09-02',:number_of_students=> 123,:class_start_date=>'2020-09-02',:school_id=>'001U0000007gj6EIAQ',:book_id=>'zA9gH44q',:name=> 'OS Salesforce API',:stage_name=> 'Confirm Adoption Won',:salesforce_updated=>false})
    VCR.use_cassette('RetryFailedOpportunities/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  it 'retry opportunity' do
    RetryFailedOpportunities.call
    updated_opp = Opportunity.first
    expect(updated_opp.salesforce_updated).to eq true
  end
end
