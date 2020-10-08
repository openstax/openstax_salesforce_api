require 'rails_helper'
require 'vcr_helper'
require 'spec_helper'

RSpec.describe "Opportunities", type: :request, vcr: VCR_OPTS do

  before(:all) do
    @opportunity = FactoryBot.create :api_opportunity
    @request_header = request_header_with_token
    VCR.use_cassette('OpportunitiesController/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  it "returns a successful response for all opportunities" do
    get "/api/v1/opportunities/", :headers => @request_header
    expect(response).to be_successful
  end

  it "returns one opportunity" do
    get "/api/v1/opportunities/" + @opportunity.salesforce_id, :headers => @request_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "returns opportunity using os_accounts_id" do
    get "/api/v1/opportunities?os_accounts_id=" + @opportunity.os_accounts_id, :headers => @request_header
    expect(JSON.parse(response.body).size).to eq(1)
    expect(response).to have_http_status(:success)
  end

  it 'create new opportunity' do
    opportunity_data = create_new_opportunity_data
    headers = { "ACCEPT" => "application/json", "Authorization" => @request_header["Authorization"] }
    post "/api/v1/opportunities", :params => opportunity_data, :headers => headers

    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:success)
  end

  it 'update opportunity' do
    @proxy = SalesforceProxy.new
    @proxy.setup_cassette
    opportunity_data = create_update_opportunity_data
    headers = { "ACCEPT" => "application/json", "Authorization" => @request_header["Authorization"] }
    put "/api/v1/opportunities/" + @opportunity.id.to_s, :params => opportunity_data, :headers => headers

    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:success)
  end

  def create_new_opportunity_data
    opportunity_data = { opportunity: {
      'salesforce_id': '',
      'term_year':'2019 - 20 Spring',
      'book_name':'Behavior',
      'contact_id':'0037X00000cVyfIQAS',
      'new':true,
      'close_date':'2020-09-02',
      'number_of_students': 123,
      'class_start_date':'2020-09-02',
      'school_id':'001U0000007gj6EIAQ',
      'book_id':'zA9gH44q',
      'name': 'OS Salesforce API',
      'stage_name': 'Confirm Adoption Won'
      }
    }
  end

    def create_update_opportunity_data

        opportunity_data = { opportunity: {
          'id':'',
            'salesforce_id':'0067X000007eQMeQAM',
            'term_year':'2019 - 20 Spring',
            'book_name':'Behavior',
            'contact_id':'0037X00000cVyfIQAS',
            'new':true,
            'close_date':'2020-09-02',
            'number_of_students': 123,
            'class_start_date':'2020-09-02',
            'school_id':'001U0000007gj6EIAQ',
            'book_id':'zA9gH44q',
            'name': 'OS Salesforce API',
            'stage_name': 'Confirm Adoption Won'
        }
        }
    end

end
