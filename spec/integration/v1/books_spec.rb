require 'swagger_helper'

RSpec.describe 'api/v1/books', type: :request do
  before do
    allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
  end

  before(:all) do
    @book = FactoryBot.create :api_book
    @contact = create_contact(salesforce_id: '0030v00000UlS9yAAF')
    @dk_token = doorkeeper_token
  end

  path '/api/v1/books' do
    get 'Return 404 error for index call' do
      tags 'Books'
      produces 'application/json'
      security [apiToken: []]

      response '404', 'not found' do
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

        let(:id) { @book.salesforce_id }
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

  path '/api/v1/books/search' do
    get 'Return book by name' do
      tags 'Books'
      consumes 'application/json'
      security [apiToken: []]

      parameter name: :name, in: :query, type: :string

      response '200', 'book found' do

        let(:name) { @book.name }
        let(:HTTP_COOKIE) { oxa_cookie }

        run_test!
      end
    end

    get 'Return book by name using token' do
      tags 'Books'
      consumes 'application/json'

      parameter name: :name, in: :query, type: :string

      parameter({
                  in: :header,
                  type: :string,
                  name: :Authorization,
                  required: true,
                  description: 'Doorkeeper token'
                })

      response '200', 'book found' do
        let(:name) { @book.name }
        let(:Authorization) { "Bearer #{@dk_token}" }

        run_test!
      end
    end
  end
end
