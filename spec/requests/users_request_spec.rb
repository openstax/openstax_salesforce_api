require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Users', type: :request do
  before(:all) do
    opportunity = FactoryBot.create :api_opportunity
    contact = FactoryBot.create(:api_contact, salesforce_id: '0037X00000cVyfKQAS')
    lead = FactoryBot.create :api_lead
  end

  it 'returns a failure response because of missing cookie' do
    get '/api/v1/users'
    expect(response).to have_http_status(:bad_request)
  end

  it 'returns data for user in cookie' do
    headers = set_cookie
    get '/api/v1/users', :headers => headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

end
