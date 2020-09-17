require 'rails_helper'
require 'vcr_helper'
require 'push_opportunity_to_salesforce'

RSpec.describe PushOpportunityToSalesforce, type: :routine, vcr: VCR_OPTS do
  before(:all) do
    VCR.use_cassette('PushOpportunityToSalesforce/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  it 'create new opportunity' do

    opportunity_data = {
        'id':'',
        'term_year':'2019 - 20 Spring',
        'book_name':'Behavior',
        'contact_id':'0037X00000cVyfIQAS',
        'new':true,
        'close_date':'2020-09-02',
        'type':"New Business",
        'number_of_students': 123,
        'class_start_date':'2020-09-02',
        'school_id':'001U0000007gj6EIAQ',
        'book_id':'zA9gH44q',
        'name': 'OS Salesforce API'
    }
    push_opportunity = PushOpportunityToSalesforce.new
    opportunity = push_opportunity.create_new_opportunity(opportunity_data)

    expect(opportunity.school_id).to eq '001U0000007gj6EIAQ'

  end

  it 'update existing opportunity' do

    opportunity_data = {
        'salesforce_id':'0067X000007eQMeQAM',
        'book_name':'Behavior',
        'contact_id':'0037X00000cVyfIQAS',
        'new':false,
        'close_date':'2020-09-02',
        'type':"Renewal - Verified",
        'number_of_students': 123,
        'class_start_date':'2020-09-02',
        'school_id':'001U0000007gj6EIAQ',
        'book_id':'zA9gH44q',
        'name': 'OS Salesforce API Update'
    }

    push_opportunity = PushOpportunityToSalesforce.new
    opportunity = push_opportunity.update_opportunity(opportunity_data)

    expect(opportunity.id).to eq '0067X000007eQMeQAM'

  end

end
