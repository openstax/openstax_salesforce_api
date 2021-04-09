require 'rails_helper'
require 'vcr_helper'
require 'spec_helper'

RSpec.describe "Opportunities", type: :request, vcr: VCR_OPTS do
  before do
    allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
  end

  before(:all) do
    @opportunity = FactoryBot.create :api_opportunity
    # needed for cookie check
    contact = create_contact
    @headers = set_cookie
    @token_header = create_token_header
    opportunity = FactoryBot.create(:api_opportunity, {:salesforce_id=>'0062F00000BG056QAD',:contact_id=>'0032F00000cfZQhQAM', :school_id=>'0012F00000iPxe9QAC'})
    VCR.use_cassette('OpportunitiesController/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  it "returns a failure response because of missing cookie" do
    get '/api/v1/opportunities/?os_accounts_id=1'
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns one opportunity" do
    get "/api/v1/opportunities/" + @opportunity.salesforce_id + '?os_accounts_id=1', :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "returns one opportunity with token" do
    get "/api/v1/opportunities/" + @opportunity.salesforce_id + '?os_accounts_id=1', :headers => @token_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "returns opportunity using os_accounts_id" do
    get "/api/v1/opportunities/search?os_accounts_id=" + @opportunity.os_accounts_id, :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "returns opportunity using os_accounts_id with token" do
    get "/api/v1/opportunities/search?os_accounts_id=" + @opportunity.os_accounts_id, :headers => @token_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it 'create new opportunity' do
    opportunity_data = create_new_opportunity_data
    headers = set_cookie
    headers["ACCEPT"] = "application/json"
    post "/api/v1/opportunities", :params => opportunity_data, :headers => headers

    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:success)
  end

  it 'create new opportunity with token' do
    opportunity_data = create_new_opportunity_data
    headers = create_token_header
    headers["ACCEPT"] = "application/json"
    post "/api/v1/opportunities", :params => opportunity_data, :headers => headers

    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:success)
  end

  it 'update opportunity' do
    @proxy = SalesforceProxy.new
    @proxy.setup_cassette
    opportunity_data = create_update_opportunity_data
    headers = set_cookie
    headers["ACCEPT"] = "application/json"
    put "/api/v1/opportunities/" + @opportunity.id.to_s, :params => opportunity_data, :headers => headers

    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:success)
  end

  it 'update opportunity with token' do
    @proxy = SalesforceProxy.new
    @proxy.setup_cassette
    opportunity_data = create_update_opportunity_data
    headers = create_token_header
    headers["ACCEPT"] = "application/json"
    put "/api/v1/opportunities/" + @opportunity.id.to_s, :params => opportunity_data, :headers => headers

    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:success)
  end

  def create_new_opportunity_data
    opportunity_data = { opportunity: {
      'salesforce_id': '',
      'term_year':'2019 - 20 Spring',
      #'book_name':'Behavior',
      'contact_id':'0032F00000cfZQhQAM',
      'new':true,
      'close_date':'2020-09-02',
      'number_of_students': 123,
      'class_start_date':'2020-09-02',
      'school_id':'0012F00000iPxe9QAC',
      'book_id':'zA9gH44q',
      'name': 'OS Salesforce API',
      'stage_name': 'Confirm Adoption Won'
      }
    }
  end

  def create_update_opportunity_data
      opportunity_data = { opportunity: {
          'id':'',
          'salesforce_id':'0062F00000BG056QAD',
          'term_year':'2019 - 20 Spring',
          'book_name':'Behavior',
          'contact_id':'0032F00000cfZQhQAM',
          'new':true,
          'close_date':'2020-09-02',
          'number_of_students': 123,
          'class_start_date':'2020-09-02',
          'school_id':'0012F00000iPxe9QAC',
          'book_id':'zA9gH44q',
          'name': 'OS Salesforce API',
          'stage_name': 'Confirm Adoption Won'
        }
      }
  end
end
