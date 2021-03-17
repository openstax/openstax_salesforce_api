require "rails_helper"

RSpec.describe "CORS", type: :request do
  before do
    allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
  end

  it "allows the request" do
    headers = { "HTTP_ORIGIN" => "http://www.example.com" }
    post "/api/v1/opportunities", :headers => headers
    expect(response.headers["Access-Control-Allow-Methods"]).to eq("GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD")
    expect(response.headers["Access-Control-Allow-Origin"]).to eq('http://www.example.com')
  end

  it "denies the request" do
    headers = { "HTTP_ORIGIN" => "http://www.badexample.com" }
    post "/api/v1/opportunities", :headers => headers
    expect(response.headers).not_to include("Access-Control-Allow-Methods")
    expect(response.headers).not_to include("Access-Control-Allow-Origin")
  end
end
