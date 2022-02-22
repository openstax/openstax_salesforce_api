require 'swagger_helper'

RSpec.describe 'Contacts API', type: :request do
  path '/api/v1/contacts/{id}' do
    get 'Get Contact information' do
      tags 'Contacts'
      produces 'application/json'
      security [cookieAuth: []]
      parameter name: :id, in: :path, type: :string

      contact = FactoryBot.create :contact
      let(:id) { contact.salesforce_id }

      response '200', 'can fetch contact' do
        let(:oxa_dev) { oxa_dev_cookie }
        schema type: :object,
               properties: {
                 salesforce_id: { type: :string },
                 name: { type: :string },
                 first_name: { type: :string },
                 last_name: { type: :string },
                 faculty_confirmed_date: { type: :string },
                 faculty_verified: { type: :string },
                 last_modified_at: { type: :datetime },
                 school_id: { type: :string },
                 school_type: { type: :string },
                 adoption_status: { type: :string },
                 created_at: { type: :string },
                 updated_at: { type: :string },
                 grant_tutor_access: { type: :boolean }
               },
               required: %w[salesforce_id name]
        # for now, we are just making sure the endpoints are secured - need to figure out cookie auth
        # with rswag
        # run_test!
        pending('SSO Auth not setup for testing')
      end

      response '401', 'not authorized without cookie' do
        run_test!
      end
    end
  end

  path '/api/v1/contacts/add_school' do
    contact = FactoryBot.create :contact
    let(:contact_id) { contact.salesforce_id }
    let(:school_id) { contact.school_id }

    parameter name: :contact_id, in: :request, schema: {
      type: :object,
      properties: {
        contact_id: { type: :string },
        school_id: { type: :string }
      },
      required: %w[contact_id school_id]
    }

    post ' Add school to a contact' do
      response '200', 'school added to contact' do
        # run_test!
        pending('SSO Auth not setup for testing')
      end

      response '401', 'not authorized without cookie' do
        run_test!
      end
    end
  end

  path '/api/v1/contacts/set_primary_school' do
    parameter name: :contact_id, in: :request, schema: {
      type: :object,
      properties: {
        contact_id: { type: :string },
        school_id: { type: :string }
      },
      required: %w[contact_id school_id]
    }

    post 'Set primary school on a contact' do
      response '200', 'primary school set' do
        # run_test!
        pending('SSO Auth not setup for testing')
      end

      response '401', 'not authorized without cookie' do
        run_test!
      end
    end
  end

  path '/api/v1/contacts/remove_school' do
    parameter name: :contact_id, in: :request, schema: {
      type: :object,
      properties: {
        contact_id: { type: :string },
        school_id: { type: :string }
      },
      required: %w[contact_id school_id]
    }

    delete 'Remove school from a contact' do
      response '200', 'school deleted' do
        # run_test!
        pending('SSO Auth not setup for testing')
      end

      response '401', 'not authorized without cookie' do
        run_test!
      end
    end
  end
end
