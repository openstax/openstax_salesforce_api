require 'rails_helper'
#require 'byebug'

RSpec.describe 'api/v1/users', type: :request, vcr: VCR_OPTS do
  before do
    allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
  end

  before(:all) do
    @ox_uuid = search_accounts_result
    @lead = FactoryBot.create :lead
    @contact = create_contact
    @opportunity = FactoryBot.create :opportunity, contact_id: @contact.salesforce_id

    VCR.use_cassette('sfapi/sf_setup', VCR_OPTS) do
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
          ox_uuid: { type: :string },
          opportunities: { type: :array },
          contact: { type: :array },
          schools: { type: :array },
          leads: { type: :array },
          subscriptions: { type: :array }
        }
      }
      #byebug
      response '200', 'user retrieved' do
        let(:HTTP_COOKIE) { set_cookie }
        run_test! do |response|
          json_response = JSON.parse(response.body)
          expect(json_response.size).to be >= 1
          expect(response).to have_http_status(:success)
          expect(json_response.keys).to contain_exactly('ox_uuid', 'opportunities', 'contact', 'schools', 'leads', 'subscriptions')
        end
      end

      #byebug
      response '401', 'invalid cookie' do
        let(:HTTP_COOKIE) { 'invalid' }
        run_test! do |response|
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
