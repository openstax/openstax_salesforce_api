require 'rails_helper'

RSpec.describe "Contacts", type: :request do

  before(:all) do
    @contact = Contact.where(salesforce_id: '003U000001i3mWpIAI')
    if @contact.empty?
      @contact = FactoryBot.create(:api_contact, salesforce_id: '003U000001i3mWpIAI')
    end
    @headers = set_cookie
  end

  it "returns a failure response because of missing cookie" do
    get '/api/v1/contacts'
    expect(response).to have_http_status(:bad_request)
  end

  it 'returns all contacts' do
    get '/api/v1/contacts', :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "returns a successful response for contact by email" do
    email = if @contact.is_a?(ActiveRecord::Relation)
              @contact[0]['email']
            else
              @contact.email
            end
    get '/api/v1/contacts/?email=' + email, :headers => @headers
    expect(response).to have_http_status(:success)
  end

  it "return one contact by id" do
    id = if @contact.is_a?(ActiveRecord::Relation)
           @contact[0]['id']
         else
           @contact.id
         end
    get "/api/v1/contacts/#{id}", :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
