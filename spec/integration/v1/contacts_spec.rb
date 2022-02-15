require 'rails_helper'

RSpec.describe 'api/v1/contacts', type: :request do
  before do
    allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
  end

  before(:all) do
    @contact = create_contact(salesforce_id: '0030v00000UlS9yAAF')
  end

  path '/api/v1/contacts/{id}' do

    get 'Return one contact' do
      tags 'Contacts'
      consumes 'application/json'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :id, in: :path, type: :string

      response '200', 'contact found' do
        schema type: :object,
               properties: {
                 salesforce_id: { type: :string },
                 name: { type: :string },
                 first_name: { type: :string },
                 last_name: { type: :string },
                 email: { type: :string },
                 email_alt: { type: :string },
                 faculty_confirmed_date: { type: :string },
                 faculty_verified: { type: :string },
                 last_modified_at: { type: :datetime },
                 school_id: { type: :string },
                 school_type: { type: :string },
                 send_faculty_verification_to: { type: :string },
                 all_emails: { type: :string },
                 confirmed_emails: { type: :string },
                 adoption_status: { type: :string },
                 created_at: { type: :string },
                 updated_at: { type: :string },
                 grant_tutor_access: { type: :boolean }
               },
               required: %w[salesforce_id name]

        let(:id) { @contact.salesforce_id }
        let(:HTTP_COOKIE) { oxa_cookie }
        run_test!
      end

      response '404', 'contact not found' do
        let(:id) { 0 }
        let(:HTTP_COOKIE) { oxa_cookie }
        run_test!
      end

      response '401', 'invalid sso cookie' do
        let(:id) { @contact.id }
        let(:HTTP_COOKIE) { 'invalid' }

        run_test! do  |response|
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  path '/api/v1/contacts/search' do
    get 'Return contact by email' do
      tags 'Contacts'
      consumes 'application/json'
      security [apiToken: []]

      parameter name: :email, in: :query, type: :string

      response '200', 'contact found' do

        let(:email) { @contact.email }
        let(:HTTP_COOKIE) { oxa_cookie }

        run_test!
      end
    end
  end
end
