require 'rails_helper'

RSpec.describe "Contacts", type: :request do

  it 'returns all contacts' do
    get '/api/v1/contacts'
    expect(JSON.parse(response.body).size).to eq(12)
    expect(response).to have_http_status(:success)
  end

  it "return one contact" do
    contact = Contact.first
    get '/api/v1/contacts/' + contact.salesforce_id
    expect(JSON.parse(response.body).size).to eq(1)
    expect(response).to have_http_status(:success)
  end
end
