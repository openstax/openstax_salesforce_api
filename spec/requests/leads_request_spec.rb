require 'rails_helper'
require 'spec_helper'

RSpec.describe "Leads", type: :request do

  before(:all) do
    @lead = FactoryBot.create :api_lead
    @request_header = request_header_with_token
  end

  it 'returns all leads' do
    get '/api/v1/leads', :headers => @request_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one lead by id" do
    get "/api/v1/leads/#{@lead.id}", :headers => @request_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return leads unauthorized request" do
    get "/api/v1/leads/"
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:unauthorized)
  end
end
