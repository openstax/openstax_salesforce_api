require 'rails_helper'
require 'spec_helper'

RSpec.describe "Books", type: :request do

  before(:all) do
    @book = FactoryBot.create :api_book
    # needed for cookie check
    contact = create_contact
    @headers = set_cookie
  end

  it "returns a failure response because of missing cookie" do
    get '/api/v1/books/?name=' + @book.name
    expect(response).to have_http_status(:bad_request)
  end

  it 'returns all books' do
    get '/api/v1/books', :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it 'returns a successful response for book by name' do
    get '/api/v1/books/?name=' + @book.name, :headers => @headers
    expect(response).to have_http_status(:success)
  end

  it "return one book by id" do
    get "/api/v1/books/#{@book.salesforce_id}", :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
