require 'rails_helper'

RSpec.describe "Contacts", type: :request do

  before(:all) do
    @contact = FactoryBot.create :api_contact
  end

  it 'returns all contacts' do
    get '/api/v1/contacts'
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one contact by id" do
    get "/api/v1/contacts/#{@contact.id}"
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
