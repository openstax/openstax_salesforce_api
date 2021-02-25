require 'rails_helper'
require 'vcr_helper'
require 'spec_helper'
require 'rake'

RSpec.describe 'Lists', type: :request, vcr: VCR_OPTS do

  before(:all) do
    @contact = create_contact(salesforce_id: '0036f00003HhsOlAAJ')

    VCR.use_cassette('Pardot/lists.yml', VCR_OPTS) do
      # this records the pardot:update_lists command to cassettes/Pardot/lists.yml, remove this file to rerecord
      OpenstaxSalesforceApi::Application.load_tasks
      Rake::Task['pardot:update_lists'].invoke
    end
  end

  it 'lists all available mailing lists' do
    get '/api/v1/lists'
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)

    # make sure the API response includes the fields we are expecting
    expect(JSON.parse(response.body)).to include(hash_including('pardot_id'))
    expect(JSON.parse(response.body)).to include(hash_including('title'))
    expect(JSON.parse(response.body)).to include(hash_including('description'))
  end

  it 'allows a user to unsubscribe from a list' do
    get '/api/v1/lists/unsubscribe/6391/0036f00003HhsOlAAJ'
    expect(response).to have_http_status(202)
  end

  it 'allows user to subscribe to list' do
    get '/api/v1/lists/subscribe/6391/0036f00003HhsOlAAJ'
    expect(response).to have_http_status(202)
  end
end
