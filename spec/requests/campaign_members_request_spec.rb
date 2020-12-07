require 'rails_helper'
require 'spec_helper'

RSpec.describe "CampaignMembers", type: :request do

  before(:all) do
    @campaign_member = FactoryBot.create :api_campaign_member
    @contact = Contact.where(salesforce_id: '003U000001i3mWpIAI')
    if @contact.blank?
      @contact = FactoryBot.create(:api_contact, salesforce_id: '003U000001i3mWpIAI')
    end
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
