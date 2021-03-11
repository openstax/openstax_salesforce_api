require 'swagger_helper'

RSpec.describe 'api/v1/books', type: :request do
  before(:all) do
    @book = FactoryBot.create :api_book
    @contact = create_contact(salesforce_id: '0030v00000UlS9yAAF')
  end

  path '/api/v1/books' do
    get 'List all Books' do
      tags 'Books'
      produces 'application/json'
      security [apiToken: []]
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
      response '200', 'books retrieved' do
        let(:book) { @book }
        let(:HTTP_COOKIE) { oxa_cookie }
        run_test!
      end
    end
  end

  path '/api/v1/books/{id}' do

    get 'Return one book' do
      tags 'Books'
      consumes 'application/json'
      security [apiToken: []]
      parameter name: :id, in: :path, type: :string

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
        let(:HTTP_COOKIE) { oxa_cookie }
        run_test!
      end

      response '404', 'book not found' do
        let(:id) { 25 }
        let(:HTTP_COOKIE) { oxa_cookie }
        run_test!
      end
    end
  end
end
