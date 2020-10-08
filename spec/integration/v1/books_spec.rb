require 'swagger_helper'
require 'spec_helper'

RSpec.describe 'api/v1/books', type: :request do
  before(:all) do
    @book = FactoryBot.create :api_book
    request_header = request_header_with_token
    @token = request_header['Authorization']
  end

  path '/api/v1/books' do
    get 'List all Books' do
      tags 'Books'
      consumes 'application/json'
      parameter name: :book, in: :body, schema: {
        type: :object,
        properties: {
          salesforce_id: { type: :string },
          name: { type: :string },
          created_at: { type: :string },
          updated_at: { type: :string }
        },
        required: %w[salesforce_id name]
      }
      parameter({
        :in => :header,
        :type => :string,
        :name => :Authorization,
        :required => true,
        :description => 'Client token'
      })
      response '200', 'books retrieved' do
        let(:book) { @book }
        let(:Authorization) { @token }
        run_test!
      end
    end
  end

  path '/api/v1/books/{id}' do

    get 'Return one book' do
      tags 'Books'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter({
          :in => :header,
          :type => :string,
          :name => :Authorization,
          :required => true,
          :description => 'Client token'
      })

      response '200', 'book found' do
        schema type: :object,
               properties: {
                 salesforce_id: { type: :string },
                 name: { type: :string },
                 created_at: { type: :string },
                 updated_at: { type: :string }
               },
               required: %w[salesforce_id name]

        let(:id) { @book.id }
        let(:Authorization) { @token }
        run_test!
      end

      response '404', 'book not found' do
        let(:id) { 25 }
        let(:Authorization) { @token }
        run_test!
      end
    end
  end
end
