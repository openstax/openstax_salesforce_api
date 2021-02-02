require 'rails_helper'
require 'spec_helper'

RSpec.describe "Leads", type: :request do

  before(:all) do
    @lead = FactoryBot.create :api_lead
    # needed for cookie check
    contact = create_contact
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
    get "/api/v1/leads/#{@lead.salesforce_id}", :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
