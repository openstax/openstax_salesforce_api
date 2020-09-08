require 'rails_helper'

RSpec.describe "Books", type: :request do

  before(:all) do
    @book = FactoryBot.create :api_book
  end

  it 'returns all books' do
    get '/api/v1/books'
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one book" do
    get '/api/v1/books/' + @book.salesforce_id
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
