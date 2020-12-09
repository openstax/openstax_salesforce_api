require 'rails_helper'
require 'spec_helper'

RSpec.describe "CampaignMembers", type: :request do

  before(:all) do
    @campaign_member = FactoryBot.create :api_campaign_member
    # needed for cookie check
    contact = create_contact
    @headers = set_cookie
  end

  it 'returns a failure response because of missing cookie' do
    get '/api/v1/campaign_members'
    expect(response).to have_http_status(:bad_request)
  end

  it 'returns all campaign_members' do
    get '/api/v1/campaign_members', :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one campaign_member" do
    get '/api/v1/campaign_members/' + @campaign_member.salesforce_id, :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
