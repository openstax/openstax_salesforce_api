require 'rails_helper'
require 'spec_helper'

RSpec.describe "Campaigns", type: :request do

  before(:all) do
    @campaign = FactoryBot.create :api_campaign
    @request_header = request_header_with_token
  end

  it 'returns all campaigns' do
    get '/api/v1/campaigns', :headers => @request_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one campaign" do
    get "/api/v1/campaigns/#{@campaign.id}", :headers => @request_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return campaigns unauthorized request" do
    get "/api/v1/campaigns/"
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:unauthorized)
  end
end
