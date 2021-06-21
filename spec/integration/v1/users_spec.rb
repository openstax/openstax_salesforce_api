require 'rails_helper'
require 'vcr_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request, vcr: VCR_OPTS do
  before do
    allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
  end

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
          schools: { type: :array },
          lead: { type: :array },
          subscriptions: { type: :array }
        }
      }
      response '200', 'user retrieved' do
        before do
          expect(OpenStax::Accounts::Api).to receive(:search_accounts).with('uuid:467cea6c-8159-40b1-90f1-e9b0dc26344c', options = {}).at_least(:once).and_return Hashie::Mash.new('body' => search_accounts_result)
        end
        let(:HTTP_COOKIE) { oxa_cookie }
        run_test! do |response|
          json_response = JSON.parse(response.body)
          expect(json_response.size).to be >= 1
          expect(response).to have_http_status(:success)
          expect(json_response.keys).to contain_exactly('contact', 'lead', 'schools', 'opportunity', 'subscriptions')
        end
      end

      response '401', 'invalid cookie' do
        let(:HTTP_COOKIE) { 'invalid' }
        run_test! do |response|
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
