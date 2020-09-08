require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'api/v1/schools', type: :request do

  before(:all) do
    @school = FactoryBot.create :api_school
  end

  path '/api/v1/schools' do
    get 'List all Schools' do
      tags 'Schools'
      consumes 'application/json'
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
        run_test!
      end
    end
  end

  path '/api/v1/schools/{id}' do

    get 'Return one school' do
      tags 'Schools'
      consumes 'application/json'
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
        run_test!
      end

      response '404', 'school not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end