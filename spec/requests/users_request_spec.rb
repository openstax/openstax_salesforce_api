require 'rails_helper'
require 'vcr_helper'
require 'spec_helper'

RSpec.describe 'Users', type: :request, vcr: VCR_OPTS do
  before(:all) do
    FactoryBot.create :api_opportunity
    # needed for cookie check
    create_contact
    FactoryBot.create :api_lead

    VCR.use_cassette('Users/user_api.yml', VCR_OPTS) do
    end
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
