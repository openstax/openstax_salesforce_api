require 'swagger_helper'
require 'rails_helper'
require 'spec_helper'

RSpec.describe 'api/v1/schools', type: :request do

  before(:all) do
    @school = FactoryBot.create :api_school
    @contact = create_contact
    @token_header = create_token_header
  end

  path '/api/v1/schools' do
    get 'List all Schools' do
      tags 'Schools'
      consumes 'application/json'
      security [apiToken: []]

      parameter name: :school, in: :body, schema: {
          type: :object,
          properties: {
            salesforce_id: { type: :string },
            name: { type: :string },
            school_type: { type: :string },
            location: { type: :string },
            is_kip: { type: :boolean },
            is_child_of_kip: { type: :boolean },
            created_at: { type: :string },
            updated_at: { type: :string }
          },
          required: %w[salesforce_id name school_type]
      }
      response '200', 'schools retrieved' do
        let(:school) { @school }
        let(:HTTP_COOKIE) { oxa_cookie }

        run_test!
      end

      response '401', 'no cookie' do
        let(:school) { @school }
        let(:HTTP_COOKIE) { }

        run_test!
      end

      get 'Return school by name' do
        tags 'Schools'
        consumes 'application/json'
        security [apiToken: []]

        parameter name: :name, in: :query, type: :string

        response '200', 'school found' do

          let(:name) { @school.name }
          let(:HTTP_COOKIE) { oxa_cookie }

          run_test!
        end
      end
    end
  end

  path '/api/v1/schools/{id}' do

    get 'Return one school' do
      tags 'Schools'
      consumes 'application/json'
      security [apiToken: []]

      parameter name: :id, in: :path, type: :string

      response '200', 'school found' do
        schema type: :object,
               properties: {
                 id: { type: :int },
                 salesforce_id: { type: :string },
                 name: { type: :string },
                 school_type: { type: :string },
                 location: { type: :string },
                 is_kip: { type: :boolean },
                 is_child_of_kip: { type: :boolean },
                 created_at: { type: :string },
                 updated_at: { type: :string }
               },
               required: %w[salesforce_id name school_type]

        let(:id) { @school.id }
        let(:HTTP_COOKIE) { oxa_cookie }

        run_test!
      end

      response '404', 'school not found' do
        let(:id) { 'invalid' }
        let(:HTTP_COOKIE) { oxa_cookie }
        
        run_test!
      end
    end
  end
end
