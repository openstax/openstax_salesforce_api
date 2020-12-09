require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Schools', type: :request do

  before(:all) do
    @school = FactoryBot.create :api_school
    # needed for cookie check
    contact = create_contact
    @headers = set_cookie
  end

  it 'returns a failure response because of missing cookie' do
    get '/api/v1/schools/'
    expect(response).to have_http_status(:bad_request)
  end

  it 'returns a successful response for all schools' do
    get '/api/v1/schools/', :headers => @headers
    expect(response).to have_http_status(:success)
  end

  it 'returns a successful response for school by name' do
    get '/api/v1/schools/?name=' + @school.name, :headers => @headers
    expect(response).to have_http_status(:success)
  end

  it 'returns one school by id' do
    get "/api/v1/schools/#{@school.id}", :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

end
