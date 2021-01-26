require 'rails_helper'

RSpec.describe "Contacts", type: :request do

  before(:all) do
    @contact = create_contact
    @headers = set_cookie
  end

  it "returns a failure response because of missing cookie" do
    get '/api/v1/contacts'
    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns all contacts' do
    get '/api/v1/contacts', :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "returns a successful response for contact by email" do
    get '/api/v1/contacts/?email=' + @contact.email, :headers => @headers
    expect(response).to have_http_status(:success)
  end

  it "return one contact by id" do
    get "/api/v1/contacts/#{@contact.id}", :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
