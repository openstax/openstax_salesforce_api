require 'rails_helper'
require 'spec_helper'

RSpec.describe "Schools", type: :request do

  before(:all) do
    @school = FactoryBot.create :api_school
    @request_header = request_header_with_token
  end

  it "returns a successful response for all schools" do
    get "/api/v1/schools/", :headers => @request_header
    expect(response).to be_successful
  end

  it "returns one school by id" do
    get "/api/v1/schools/#{@school.id}", :headers => @request_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return schools unauthorized request" do
    get "/api/v1/schools/"
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:unauthorized)
  end

end
