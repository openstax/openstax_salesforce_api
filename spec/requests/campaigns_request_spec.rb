require 'rails_helper'
require 'spec_helper'

RSpec.describe "Campaigns", type: :request do
  before do
    allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
  end

  before(:all) do
    @campaign = FactoryBot.create :api_campaign
    # needed for cookie check
    contact = create_contact(salesforce_id: '0030v00000UlS9yAAF')
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

  it "return one campaign using Salesforce id" do
    get "/api/v1/campaigns/#{@campaign.salesforce_id}", :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one campaign using Salesforce id with token" do
    get "/api/v1/campaigns/#{@campaign.salesforce_id}", :headers => @token_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return failure response for one campaign using invalid Salesforce id" do
    get "/api/v1/campaigns/invalid", :headers => @headers
    expect(response).to have_http_status(:not_found)
  end
end
