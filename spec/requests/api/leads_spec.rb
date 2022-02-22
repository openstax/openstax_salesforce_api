require 'swagger_helper'

RSpec.describe 'Leads API', type: :request do
  path '/api/v1/leads/{id}' do
    get 'Get Lead information' do
      tags 'Contacts'
      produces 'application/json'
      security [cookieAuth: []]
      parameter name: :id, in: :path, type: :string

      contact = FactoryBot.create :contact
      let(:id) { contact.salesforce_id }

      response '200', 'can fetch contact' do
        let(:oxa_dev) { oxa_dev_cookie }
        lead = FactoryBot.create :lead
        parameter name: :lead_data, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string },
            first_name: { type: :string },
            last_name: { type: :string },
            salutation: { type: :string },
            subject: { type: :string },
            school: { type: :string },
            phone: { type: :string },
            website: { type: :string },
            status: { type: :string },
            email: { type: :string },
            source: { type: :string },
            newsletter: { type: :boolean },
            newsletter_opt_in: { type: :boolean },
            adoption_status: { type: :string },
            num_students: { type: :integer },
            os_accounts_id: { type: :integer },
            accounts_uuid: { type: :string },
            application_source: { type: :string },
          },
        }

        # run_test!
        pending('SSO Auth not setup for testing')
      end

      response '202', 'lead created' do
        pending('SSO Auth not setup for testing')
      end

      response '401', 'not authorized without cookie' do
        run_test!
      end
    end
  end
end
