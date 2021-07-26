require 'rails_helper'
require 'spec_helper'

RSpec.describe "Books", type: :request do
  before do
    allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
  end

  before(:all) do
    @book = FactoryBot.create :api_book
    # needed for cookie check
    contact = create_contact(salesforce_id: '0030v00000UlS9yAAF')
    @headers = set_cookie
    @token_header = create_token_header
  end

  it "returns a failure response because of missing cookie" do
    get '/api/v1/books/?name=' + @book.name
    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns failure for index call' do
    get '/api/v1/books', :headers => @headers
    expect(response).to have_http_status(:not_found)
  end

  it 'returns a successful response for book by name' do
    get '/api/v1/books/search?name=' + @book.name, :headers => @headers
    expect(response).to have_http_status(:success)
  end

  it 'returns a successful response for book by name using token' do
    get '/api/v1/books/search?name=' + @book.name, :headers => @token_header
    expect(response).to have_http_status(:success)
  end

  it "return one book by id" do
    get "/api/v1/books/#{@book.salesforce_id}", :headers => @headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "return one book by id using token" do
    get "/api/v1/books/#{@book.salesforce_id}", :headers => @token_header
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end
end
