require 'rails_helper'

RSpec.describe 'Schools', type: :request do

  before(:all) do
    @school = FactoryBot.create :api_school
  end

  it 'returns a successful response for all schools' do
    get '/api/v1/schools/'
    expect(response).to have_http_status(:success)
  end

  it 'returns a successful response for school by name' do
    get '/api/v1/schools/?name=' + @school.name
    expect(response).to have_http_status(:success)
  end

  it 'returns one school by id' do
    get "/api/v1/schools/#{@school.id}"
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

end
