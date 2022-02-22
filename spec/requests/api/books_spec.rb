require 'rails_helper'

RSpec.describe 'Books API', type: :request do
  path '/api/v1/books/search' do
    get 'Search books' do
      tags 'Books'
      produces 'application/json'
      security [cookieAuth: []]

      response '200', 'can search books' do
        let(:oxa_dev) { oxa_dev_cookie }
        book = FactoryBot.create :book
        schema type: :object,
               properties: {
                 id: { type: :string },
                 salesforce_id: { type: :array },
                 name: { type: :array }
               },
               required: ['id']
        # for now, we are just making sure the endpoints are secured - need to figure out cookie auth
        # with rswag
        # run_test!
        pending('SSO Auth not setup for testing')
      end

      response '401', 'not authorized without cookie' do
        run_test!
      end
    end
  end
end
