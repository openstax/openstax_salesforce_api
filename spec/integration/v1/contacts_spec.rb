require 'swagger_helper'

RSpec.describe 'api/v1/contacts', type: :request do
  path '/api/v1/contacts' do
    get 'List all Contacts' do
      tags 'Contacts'
      consumes 'application/json'
      parameter name: :contact, in: :body, schema: {
        type: :object,
        properties: {
          salesforce_id: { type: :string },
          name: { type: :string },
          first_name: { type: :string },
          last_name: { type: :string },
          email: { type: :string },
          email_alt: { type: :string },
          faculty_confirmed_date: { type: :datetime },
          faculty_verified: { type: :string },
          last_modified_at: { type: :datetime },
          school_id: { type: :string },
          school_type: { type: :string },
          send_faculty_verification_to: { type: :string },
          all_emails: { type: :string },
          confirmed_emails: { type: :string },
          adoption_status: { type: :string },
          created_at: { type: :datetime },
          updated_at: { type: :datetime },
          grant_tutor_access: { type: :boolean }
        },
        required: %w[salesforce_id name]
      }
      response '200', 'contacts retrieved' do
        let(:contact) { FactoryBot.create :contact }
        run_test!
      end
    end
  end

  path '/api/v1/contacts/{id}' do

    get 'Return one contact' do
      tags 'Contacts'
      consumes 'application/json'
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
                 faculty_confirmed_date: { type: :datetime },
                 faculty_verified: { type: :string },
                 last_modified_at: { type: :datetime },
                 school_id: { type: :string },
                 school_type: { type: :string },
                 send_faculty_verification_to: { type: :string },
                 all_emails: { type: :string },
                 confirmed_emails: { type: :string },
                 adoption_status: { type: :string },
                 created_at: { type: :datetime },
                 updated_at: { type: :datetime },
                 grant_tutor_access: { type: :boolean }
               },
               required: %w[salesforce_id name]

        let(:id) { Contact.create(name: 'William Marsh Rice', salesforce_id: 'AZ44335AQ').id }
        run_test!
      end

      response '404', 'contact not found' do
        let(:id) { 25 }
        run_test!
      end
    end
  end
end