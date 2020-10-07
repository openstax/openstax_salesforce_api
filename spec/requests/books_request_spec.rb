require 'rails_helper'
require 'spec_helper'

RSpec.describe "Books", type: :request do

  before(:all) do
    @book = FactoryBot.create :api_book
    @request_header = request_header_with_token
  end

  it 'returns all books' do
    get '/api/v1/books', :headers => @request_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one book by id" do
    get "/api/v1/books/#{@book.id}", :headers => @request_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return book unauthorized request" do
    get "/api/v1/books/#{@book.id}"
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:unauthorized)
  end
end
