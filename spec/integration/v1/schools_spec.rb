require 'swagger_helper'
require 'rails_helper'
require 'spec_helper'

RSpec.describe 'api/v1/schools', type: :request do

  before(:all) do
    @school = FactoryBot.create :api_school
    request_header = request_header_with_token
    @token = request_header['Authorization']
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
      parameter({
          :in => :header,
          :type => :string,
          :name => :Authorization,
          :required => true,
          :description => 'Client token'
      })
      response '200', 'schools retrieved' do
        let(:school) { @school }
        let(:Authorization) { @token }
        run_test!
      end
    end
  end

  path '/api/v1/schools/{id}' do

    get 'Return one school' do
      tags 'Schools'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter({
          :in => :header,
          :type => :string,
          :name => :Authorization,
          :required => true,
          :description => 'Client token'
      })

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
        let(:Authorization) { @token }
        run_test!
      end

      response '404', 'school not found' do
        let(:id) { 'invalid' }
        let(:Authorization) { @token }
        run_test!
      end
    end
  end
end
