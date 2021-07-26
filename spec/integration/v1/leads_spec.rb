require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'api/v1/leads', type: :request do
  before do
    allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
  end

  before(:all) do
    @lead = FactoryBot.create :api_lead
    @contact = create_contact(salesforce_id: '0030v00000UlS9yAAF')
    @dk_token = doorkeeper_token
  end

  path '/api/v1/leads/' do
    get 'Return 404 error for index call' do
      tags 'Leads'
      consumes 'application/json'
      security [apiToken: []]
      response '404', 'not found' do
        let(:HTTP_COOKIE) { oxa_cookie }

        run_test!
      end
    end
  end

  path '/api/v1/leads/{id}' do

    get 'Return one lead' do
      tags 'Leads'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      security [apiToken: []]

      response '200', 'lead found' do
        schema type: :object,
               properties: {
                 salesforce_id: { type: :string },
                 name: { type: :string },
                 first_name: { type: :string },
                 last_name: { type: :string },
                 salutation: { type: :string },
                 subject: { type: :string },
                 school: { type: :datetime },
                 phone: { type: :string },
                 website: { type: :datetime },
                 status: { type: :string },
                 email: { type: :string },
                 source: { type: :string },
                 newsletter: { type: :string },
                 newsletter_opt_in: { type: :string },
                 adoption_status: { type: :string },
                 num_students: { type: :integer },
                 os_accounts_id: { type: :string },
                 accounts_uuid: { type: :string },
                 application_source: { type: :string },
                 role: { type: :string },
                 who_chooses_books: { type: :string },
                 verification_status: { type: :string },
                 finalize_educator_signup: { type: :boolean },
                 created_at: { type: :string },
                 updated_at: { type: :string }
               },
               required: %w[salesforce_id name]

        let(:id) { @lead.salesforce_id }
        let(:HTTP_COOKIE) { oxa_cookie }

        run_test!
      end

      response '404', 'lead not found' do
        let(:id) { 'invalid' }
        let(:HTTP_COOKIE) { oxa_cookie }

        run_test!
      end
    end
  end

  path '/api/v1/leads/search' do
    get 'Return lead by os_accounts_id' do
      tags 'Leads'
      consumes 'application/json'
      security [apiToken: []]

      parameter name: :os_accounts_id, in: :query, type: :string

      response '200', 'lead found' do

        let(:os_accounts_id) { @lead.os_accounts_id }
        let(:HTTP_COOKIE) { oxa_cookie }

        run_test!
      end
    end

    get 'Return lead by os_accounts_id using token' do
      tags 'Leads'
      consumes 'application/json'

      parameter name: :os_accounts_id, in: :query, type: :string

      parameter({
                  in: :header,
                  type: :string,
                  name: :Authorization,
                  required: true,
                  description: 'Doorkeeper token'
                })

      response '200', 'lead found' do
        let(:os_accounts_id) { @lead.os_accounts_id }
        let(:Authorization) { "Bearer #{@dk_token}" }

        run_test!
      end
    end
  end
end
