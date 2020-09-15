require 'rails_helper'

RSpec.describe "Opportunities", type: :request, vcr: VCR_OPTS do

  before(:all) do
    @opportunity = FactoryBot.create :api_opportunity
  end

  it "returns a successful response for all opportunities" do
    get "/api/v1/opportunities/"
    expect(response).to be_successful
  end

  it "returns one opportunity" do
    get "/api/v1/opportunities/" + @opportunity.salesforce_id
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "returns opportunity using os_accounts_id" do
    opportunity = Opportunity.first
    get "/api/v1/opportunities?os_accounts_id=" + opportunity.os_accounts_id
    expect(JSON.parse(response.body).size).to eq(1)
    expect(response).to have_http_status(:success)
  end

  it 'create new opportunity' do
    VCR.use_cassette('OpportunitiesController/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
      opportunity_data = create_opportunity_data
      headers = { "ACCEPT" => "application/json" }
      post "/api/v1/opportunities", :params => opportunity_data, :headers => headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:created)
    end
  end

  def create_opportunity_data
    opportunity_data = {
        'id':'',
        'term_year':'2019 - 20 Spring',
        'book_name':'Behavior',
        'contact_id':'003U000001ijfa2IAA',
        'new':true,
        'close_date':'2020-09-02',
        'type':"New Business",
        'number_of_students': 123,
        'class_start_date':'2020-09-02',
        'school_id':'001R000001hawseIAA',
        'book_id':'zA9gH44q',
        'name': 'OS Salesforce API'
    }
  end

end
