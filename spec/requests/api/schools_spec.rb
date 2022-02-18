require 'rails_helper'

RSpec.describe 'School API', type: :request do
  path '/api/v1/schools/search' do
    get 'Search schools' do
      tags 'Schools'
      produces 'application/json'
      security [cookieAuth: []]

      response '200', 'can search schools' do
        let(:oxa_dev) { oxa_dev_cookie }
        school = FactoryBot.create :school
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
               required: ['id']
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
end
