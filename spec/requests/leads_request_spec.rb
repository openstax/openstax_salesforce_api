require 'rails_helper'

RSpec.describe "Leads", type: :request do

  it 'returns all leads' do
    get '/api/v1/leads'
    expect(JSON.parse(response.body).size).to eq(12)
    expect(response).to have_http_status(:success)
  end

  it "return one lead" do
    lead = Lead.first
    get '/api/v1/leads/' + lead.salesforce_id
    expect(JSON.parse(response.body).size).to eq(1)
    expect(response).to have_http_status(:success)
  end
end
