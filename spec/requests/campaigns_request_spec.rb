require 'rails_helper'
require 'spec_helper'

RSpec.describe "Campaigns", type: :request do

  before(:all) do
    @campaign = FactoryBot.create :api_campaign
    @contact = Contact.where(salesforce_id: '003U000001i3mWpIAI')
    if @contact.blank?
      @contact = FactoryBot.create(:api_contact, salesforce_id: '003U000001i3mWpIAI')
    end
    @headers = set_cookie
  end

  it 'returns a failure response because of missing cookie' do
    get '/api/v1/campaigns'
    expect(response).to have_http_status(:bad_request)
  end

  it 'returns all campaigns' do
    get '/api/v1/campaigns', :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one campaign" do
    get "/api/v1/campaigns/#{@campaign.id}", :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
