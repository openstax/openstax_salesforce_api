require 'rails_helper'

RSpec.describe "Campaigns", type: :request do

  before(:all) do
    @campaign = FactoryBot.create :api_campaign
  end

  it 'returns all campaigns' do
    get '/api/v1/campaigns'
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one campaign" do
    get "/api/v1/campaigns/#{@campaign.id}"
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
