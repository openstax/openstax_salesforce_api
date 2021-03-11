require 'rails_helper'
require 'swagger_helper'
require 'vcr_helper'

RSpec.describe 'api/v1/lists', type: :request, vcr: VCR_OPTS do
  before(:all) do
    @list = FactoryBot.create :list
    @contact = create_contact(salesforce_id: '0030v00000UlS9yAAF')

    VCR.use_cassette('Pardot/lists.yml', record: :none,
                                         allow_unused_http_interactions: true,
                                         match_requests_on: %i[method]) do
      OpenstaxSalesforceApi::Application.load_tasks
      Rake::Task['pardot:update_lists'].invoke

      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  path '/api/v1/lists' do
    get 'Retrieve all public mailing lists' do
      tags 'Lists'
      consumes 'application/json'
      parameter name: :list, in: :body, schema: {
        type: :object,
        properties: {
          pardot_id: { type: :string },
          title: { type: :string },
          description: { type: :string },
          created_at: { type: :string },
          updated_at: { type: :string }
        }
      }
      response '200', 'lists retrieved' do
        let(:list) { @list }
        run_test! do |response|
          expect(JSON.parse(response.body)).to include(hash_including('pardot_id'))
          expect(JSON.parse(response.body)).to include(hash_including('title'))
          expect(JSON.parse(response.body)).to include(hash_including('description'))
        end
      end
    end
  end

  path '/api/v1/lists/{list_id}/subscribe' do
    parameter name: :list_id, in: :path, type: :string

    get 'Subscribes to a mailing list' do
      tags 'Lists'
      consumes 'application/json'
      security [apiToken: []]

      response '202', 'subscribe successful' do
        let(:list_id) { @list.pardot_id }
        let(:HTTP_COOKIE) { oxa_cookie }
        run_test!
      end
    end
  end

  path '/api/v1/lists/{list_id}/unsubscribe' do
    parameter name: :list_id, in: :path, type: :string

    get 'Unsubscribes from a mailing list' do
      tags 'Lists'
      consumes 'application/json'
      security [apiToken: []]

      response '202', 'unsubscribe successful' do
        before { @subscription = Subscription.create(list: @list, contact: @contact) }

        let(:list_id) { @list.pardot_id }
        let(:HTTP_COOKIE) { oxa_cookie }
        run_test!
      end
    end
  end
end
