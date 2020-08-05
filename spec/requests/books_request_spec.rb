require 'rails_helper'

RSpec.describe "Books", type: :request do

  it 'returns all books' do
    get '/api/v1/books'
    expect(JSON.parse(response.body).size).to eq(12)
    expect(response).to have_http_status(:success)
  end

  it "return one book" do
    book = Book.first
    get '/api/v1/books/' + book.salesforce_id
    expect(JSON.parse(response.body).size).to eq(1)
    expect(response).to have_http_status(:success)
  end
end
