require 'rails_helper'

RSpec.describe "Schools", type: :request do

  it "returns a successful response for all schools" do
    get "/api/v1/schools/"
    expect(response).to be_successful
  end

  it "returns one school" do
    school = School.first
    get "/api/v1/schools/#{school.id}"
    expect(JSON.parse(response.body).size).to eq(1)
    expect(response).to have_http_status(:success)
  end

end
