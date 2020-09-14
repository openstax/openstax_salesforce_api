require 'rails_helper'

RSpec.describe "Leads", type: :request do

  before(:all) do
    @lead = FactoryBot.create :api_lead
  end

  it 'returns all leads' do
    get '/api/v1/leads'
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one lead by id" do
    get "/api/v1/leads/#{@lead.id}"
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
