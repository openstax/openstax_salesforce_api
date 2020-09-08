require 'rails_helper'

RSpec.describe "CampaignMembers", type: :request do

  before(:all) do
    @campaign_member = FactoryBot.create :api_campaign_member
  end

  it 'returns all campaign_members' do
    get '/api/v1/campaign_members'
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one campaign_member" do
    get '/api/v1/campaign_members/' + @campaign_member.salesforce_id
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
