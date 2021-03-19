require 'rails_helper'
require 'vcr_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do

  before(:all) do
    @opportunity = FactoryBot.create :api_opportunity
    @lead = FactoryBot.create :api_lead
    @contact = create_contact(salesforce_id: '0030v00000UlS9yAAF')
  end

  path '/api/v1/users' do
    get 'Get user info' do
      tags 'Users'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          opportunity: { type: :array },
          contact: { type: :array },
          lead: { type: :array }
        }
      }

      response '200', 'user retrieved' do
        before do
          expect(OpenStax::Accounts::Api).to receive(:search_accounts).with('uuid:57bbe3d3-d630-4e9c-bc22-f86b701381a0', options = {}).and_return Hashie::Mash.new('body' => search_accounts_result)
        end
        let(:HTTP_COOKIE) { oxa_cookie }
        run_test! do |response|
          expect(JSON.parse(response.body).size).to be >= 1
          expect(response).to have_http_status(:success)
        end
      end

      response '400', 'invalid cookie' do
        let(:HTTP_COOKIE) { 'invalid' }
        run_test! do |response|
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
