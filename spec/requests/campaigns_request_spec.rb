require 'rails_helper'

RSpec.describe "Campaigns", type: :request do

  it 'returns all campaigns' do
    get '/api/v1/campaigns'
    expect(JSON.parse(response.body).size).to eq(12)
    expect(response).to have_http_status(:success)
  end

  it "return one campaign" do
    campaign = Campaign.first
    get '/api/v1/campaigns/' + campaign.salesforce_id
    expect(JSON.parse(response.body).size).to eq(1)
    expect(response).to have_http_status(:success)
  end
end
