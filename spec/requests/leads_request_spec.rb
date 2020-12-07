require 'rails_helper'
require 'spec_helper'

RSpec.describe "Leads", type: :request do

  before(:all) do
    @lead = FactoryBot.create :api_lead
    @contact = Contact.where(salesforce_id: '003U000001i3mWpIAI')
    if @contact.blank?
      @contact = FactoryBot.create(:api_contact, salesforce_id: '003U000001i3mWpIAI')
    end
    @headers = set_cookie
  end

  it 'returns a failure response because of missing cookie' do
    get '/api/v1/leads'
    expect(response).to have_http_status(:bad_request)
  end

  it 'returns all leads' do
    get '/api/v1/leads', :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it 'returns a successful response for lead by os_accounts_id' do
    get '/api/v1/leads/?os_accounts_id=' + @lead.os_accounts_id, :headers => @headers
    expect(response).to have_http_status(:success)
  end

  it "return one lead by id" do
    get "/api/v1/leads/#{@lead.id}", :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
