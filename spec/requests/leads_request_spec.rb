require 'rails_helper'
require 'spec_helper'

RSpec.describe "Leads", type: :request do
  before do
    allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
  end

  before(:all) do
    @lead = FactoryBot.create :api_lead
    # needed for cookie check
    contact = create_contact(salesforce_id: '0030v00000UlS9yAAF')
    @headers = set_cookie
    @token_header = create_token_header
  end

  it 'returns failure for index call' do
    get '/api/v1/leads', :headers => @headers
    expect(response).to have_http_status(:not_found)
  end

  it 'returns a failure response because of missing cookie' do
    get "/api/v1/leads/#{@lead.salesforce_id}"
    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns a successful response for lead by os_accounts_id' do
    get '/api/v1/leads/search?os_accounts_id=' + @lead.os_accounts_id, :headers => @headers
    expect(response).to have_http_status(:success)
  end

  it 'returns a successful response for lead by os_accounts_id with token' do
    get '/api/v1/leads/search?os_accounts_id=' + @lead.os_accounts_id, :headers => @token_header
    expect(response).to have_http_status(:success)
  end

  it "return one lead by id" do
    get "/api/v1/leads/#{@lead.salesforce_id}", :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one lead by id with token" do
    get "/api/v1/leads/#{@lead.salesforce_id}", :headers => @token_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
