require 'swagger_helper'

RSpec.describe 'api/v1/leads', type: :request do
  path '/api/v1/leads' do
    get 'List all Leads' do
      tags 'Leads'
      consumes 'application/json'
      parameter name: :contact, in: :body, schema: {
        type: :object,
        properties: {
          salesforce_id: { type: :string },
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
          newsletter: { type: :string },
          newsletter_opt_in: { type: :string },
          adoption_status: { type: :string },
          num_students: { type: :string },
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
      }
      response '200', 'leads retrieved' do
        let(:lead) { FactoryBot.create :lead }
        run_test!
      end
    end
  end

  path '/api/v1/leads/{id}' do

    get 'Return one lead' do
      tags 'Leads'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string

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
                 num_students: { type: :string },
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

        let(:id) { Lead.create(name: 'William Marsh Rice', salesforce_id: 'AZ44335AQ').id }
        run_test!
      end

      response '404', 'lead not found' do
        let(:id) { 25 }
        run_test!
      end
    end
  end
end