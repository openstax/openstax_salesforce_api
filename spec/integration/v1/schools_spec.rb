require 'swagger_helper'
require 'rails_helper'
require 'spec_helper'

RSpec.describe 'api/v1/schools', type: :request do

  before(:all) do
    @school = FactoryBot.create :api_school
    @contact = create_contact
    @dk_token = doorkeeper_token
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
    end

    get 'List all Schools using token' do
      tags 'Schools'
      consumes 'application/json'

      parameter({
                  :in => :header,
                  :type => :string,
                  :name => :Authorization,
                  :required => true,
                  :description => 'Doorkeeper token'
                })

      response '200', 'schools retrieved' do
        let(:Authorization) { "Bearer #{@dk_token}" }

        run_test!
      end

      response '401', 'no token' do
        let(:Authorization) { }

        run_test!
      end
    end
  end

  path '/api/v1/schools' do
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

      response '200', 'school found using partial name' do

        let(:name) { @school.name[0..2] }
        let(:HTTP_COOKIE) { oxa_cookie }

        run_test!
      end
    end

    get 'Return school by name using token' do
      tags 'Schools'
      consumes 'application/json'

      parameter name: :name, in: :query, type: :string

      parameter({
                  :in => :header,
                  :type => :string,
                  :name => :Authorization,
                  :required => true,
                  :description => 'Doorkeeper token'
                })

      response '200', 'school found' do
        let(:name) { @school.name }
        let(:Authorization) { "Bearer #{@dk_token}" }

        run_test!
      end

      response '200', 'school found using partial name' do
        let(:name) { @school.name[0..2] }
        let(:Authorization) { "Bearer #{@dk_token}" }

        run_test!
      end

      response '401', 'no token' do
        let(:name) { @school.name }
        let(:Authorization) { }

        run_test!
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

    get 'Return one school using token' do
      tags 'Schools'
      consumes 'application/json'

      parameter name: :id, in: :path, type: :string

      parameter({
                  :in => :header,
                  :type => :string,
                  :name => :Authorization,
                  :required => true,
                  :description => 'Doorkeeper token'
                })

      response '200', 'school found' do
        let(:id) { @school.id }
        let(:Authorization) { "Bearer #{@dk_token}" }

        run_test!
      end

      response '404', 'school not found' do
        let(:id) { 'invalid' }
        let(:Authorization) { "Bearer #{@dk_token}" }

        run_test!
      end
    end
  end
end
