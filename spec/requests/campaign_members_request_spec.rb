require 'rails_helper'

RSpec.describe "CampaignMembers", type: :request do

  it 'returns all campaign_members' do
    get '/api/v1/campaign_members'
    expect(JSON.parse(response.body).size).to eq(12)
    expect(response).to have_http_status(:success)
  end

  it "return one campaign_member" do
    campaign_member = CampaignMember.first
    get '/api/v1/campaign_members/' + campaign_member.salesforce_id
    expect(JSON.parse(response.body).size).to eq(1)
    expect(response).to have_http_status(:success)
  end
end
