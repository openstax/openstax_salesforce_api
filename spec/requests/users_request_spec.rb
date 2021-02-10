require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Users', type: :request, vcr: VCR_OPTS do
  before(:all) do
    opportunity = FactoryBot.create :api_opportunity
    # needed for cookie check
    contact = create_contact
    lead = FactoryBot.create :api_lead
  end

  it 'returns a failure response because of missing cookie' do
    get '/api/v1/users'
    expect(response).to have_http_status(:bad_request)
  end

  it 'returns data for user in cookie' do
    headers = set_cookie
    get '/api/v1/users', headers: headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

end
