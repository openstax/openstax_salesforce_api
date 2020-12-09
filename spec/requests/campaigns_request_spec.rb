require 'rails_helper'
require 'spec_helper'

RSpec.describe "Campaigns", type: :request do

  before(:all) do
    @campaign = FactoryBot.create :api_campaign
    # needed for cookie check
    contact = create_contact
    @headers = set_cookie
  end

  it 'returns a failure response because of missing cookie' do
    get '/api/v1/campaigns'
    expect(response).to have_http_status(:bad_request)
  end

  it 'returns all campaigns' do
    get '/api/v1/campaigns', :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one campaign" do
    get "/api/v1/campaigns/#{@campaign.id}", :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
