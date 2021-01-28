require 'rails_helper'
require 'spec_helper'

RSpec.describe "CampaignMembers", type: :request do

  before(:all) do
    @campaign_member = FactoryBot.create :api_campaign_member
    # needed for cookie check
    contact = create_contact
    @headers = set_cookie
    @token_header = create_token_header
  end

  it 'returns a failure response because of missing cookie' do
    get '/api/v1/campaign_members'
    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns all campaign_members' do
    get '/api/v1/campaign_members', :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it 'returns all campaign_members using token' do
    get '/api/v1/campaign_members',:headers => @token_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one campaign_member" do
    get '/api/v1/campaign_members/' + @campaign_member.salesforce_id, :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one campaign_member using token" do
    get '/api/v1/campaign_members/' + @campaign_member.salesforce_id, :headers => @token_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
