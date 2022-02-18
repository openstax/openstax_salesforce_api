require 'swagger_helper'

RSpec.describe 'Pardot Lists API', type: :request do
  path '/api/v1/lists/' do
    get 'Get Pardot list information' do
      tags 'Pardot'
      produces 'application/json'
      security [cookieAuth: []]

      response '200', 'can fetch lists' do
        let(:oxa_dev) { oxa_dev_cookie }
        schema type: :object,
               properties: {
                 pardot_id: { type: :string },
                 title: { type: :string },
                 description: { type: :string },
                 created_at: { type: :string },
                 updated_at: { type: :string }
               },
               required: %w[pardot_id title]
        # run_test!
        pending('SSO Auth not setup for testing')
      end

      response '401', 'not authorized without cookie' do
        run_test!
      end
    end
  end

  path '/api/v1/lists/{list_id}/subscribe' do
    list = FactoryBot.create :list
    let(:list_id) { list.id }

    parameter name: :list_id, in: :path, type: :string

    get 'Subscribes to a mailing list' do
      tags 'Lists'
      consumes 'application/json'
      security [apiToken: []]

      response '202', 'subscribe request processing' do
        let(:list_id) { @list.pardot_id }

        # run_test! do |response|
        #   expect(response).to have_http_status(:accepted)
        #
        #   @subscription = Subscription.where(list: @list, contact: @contact)
        #   expect(@subscription.exists?).to eq(true)
        # end
        pending('SSO Auth not setup for testing')
      end

      response '401', 'not authorized without cookie' do
        run_test!
      end
    end
  end

  path '/api/v1/lists/{list_id}/unsubscribe' do
    list = FactoryBot.create :list
    let(:list_id) { list.id }

    parameter name: :list_id, in: :path, type: :string

    get 'Unsubscribes from a mailing list' do
      tags 'Lists'
      consumes 'application/json'
      security [apiToken: []]

      response '202', 'unsubscribe request processing' do
        before do
          @subscription = Subscription.create(list: @list, contact: @contact)
        end

        # run_test!
        pending('SSO Auth not setup for testing')
      end

      response '401', 'not authorized without cookie' do
        run_test!
      end

    end
  end
end
