require 'rails_helper'
require 'spec_helper'

RSpec.describe "Contacts", type: :request do

  before(:all) do
    @contact = FactoryBot.create :api_contact
    @request_header = request_header_with_token
  end

  it 'returns all contacts' do
    get '/api/v1/contacts', :headers => @request_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one contact by id" do
    get "/api/v1/contacts/#{@contact.id}", :headers => @request_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return contact unauthorized request" do
    get "/api/v1/contacts/"
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:unauthorized)
  end
end
