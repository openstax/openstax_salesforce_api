require 'swagger_helper'
require 'spec_helper'

RSpec.describe 'api/v1/contacts', type: :request do

  before(:all) do
    @contact = FactoryBot.create :api_contact
    request_header = request_header_with_token
    @token = request_header['Authorization']
  end

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
      }
      parameter({
          :in => :header,
          :type => :string,
          :name => :Authorization,
          :required => true,
          :description => 'Client token'
      })
      response '200', 'contacts retrieved' do
        let(:contact) { @contact }
        let(:Authorization) { @token }
        run_test!
      end
    end
  end

  path '/api/v1/contacts/{id}' do

    get 'Return one contact' do
      tags 'Contacts'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter({
          :in => :header,
          :type => :string,
          :name => :Authorization,
          :required => true,
          :description => 'Client token'
      })

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

        let(:id) { @contact.id }
        let(:Authorization) { @token }
        run_test!
      end

      response '404', 'contact not found' do
        let(:id) { 25 }
        let(:Authorization) { @token }
        run_test!
      end
    end
  end
end
