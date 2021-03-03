require 'rails_helper'
require 'spec_helper'

RSpec.describe "Campaigns", type: :request do

  before(:all) do
    @campaign = FactoryBot.create :api_campaign
    # needed for cookie check
    contact = create_contact
    @headers = set_cookie
    @token_header = create_token_header
  end

  it 'returns a failure response because of missing cookie' do
    get '/api/v1/campaigns'
    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns all campaigns' do
    get '/api/v1/campaigns', :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it 'returns all campaigns with token' do
    get '/api/v1/campaigns', :headers => @token_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one campaign" do
    get "/api/v1/campaigns/#{@campaign.id}", :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one campaign with token" do
    get "/api/v1/campaigns/#{@campaign.id}", :headers => @token_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
