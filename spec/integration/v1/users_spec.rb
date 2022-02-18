require 'rails_helper'

RSpec.describe 'api/v1/users', type: :request do
  before do
    allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
  end

  before(:all) do
    @lead = FactoryBot.create :lead
    @contact = FactoryBot.create :contact
    @opportunity = FactoryBot.create :opportunity, contact_id: @contact.salesforce_id
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
      # response '200', 'user retrieved' do
      #   let(:HTTP_COOKIE) { set_cookie }
      #   run_test! do |response|
      #     json_response = JSON.parse(response.body)
      #     expect(json_response.size).to be >= 1
      #     expect(response).to have_http_status(:success)
      #     expect(json_response.keys).to contain_exactly('ox_uuid', 'opportunities', 'contact', 'schools', 'leads', 'subscriptions')
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
