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
    @contact = create_contact(salesforce_id: '0034C00000WsQ06QAF')
    VCR.use_cassette('api/v1/users/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
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
      # response '200', 'user retrieved' do
      #   let(:HTTP_COOKIE) { oxa_cookie }
      #   run_test! do |response|
      #     json_response = JSON.parse(response.body)
      #     expect(json_response.size).to be >= 1
      #     expect(response).to have_http_status(:success)
      #     expect(json_response.keys).to contain_exactly('contact', 'lead', 'schools', 'opportunity', 'subscriptions')
      #   end
      # end

      response '401', 'invalid cookie' do
        let(:HTTP_COOKIE) { 'invalid' }
        run_test! do |response|
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
