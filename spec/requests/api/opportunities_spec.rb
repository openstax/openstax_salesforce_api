require 'swagger_helper'

RSpec.describe 'Opportunities API', type: :request do
  path '/api/v1/opportunities/' do
    post 'Create an Opportunity' do
      tags 'Opportunity'
      consumes 'application/json'
      security [cookieAuth: []]

      parameter name: :opportunity_data, in: :body, schema: {
        type: :object,
        properties: {
          book_name: { type: :string },
          contact_id: { type: :string },
          new: { type: :boolean },
          close_date: { type: :string },
          number_of_students: { type: :string },
          class_start_date: { type: :string },
          school_id: { type: :string },
          book_id: { type: :string },
          name: { type: :string },
          stage_name: { type: :string }
        },
        required: %w[book_name contact_id close_date number_of_students school_id stage_name]
      }

      opportunity = FactoryBot.create :opportunity
      let(:opportunity_data) { opportunity.to_json }

      response '202', 'opportunity created' do
        let(:oxa_dev) { oxa_dev_cookie }
        # run_test!
        pending('SSO Auth not setup for testing')
      end

      response '401', 'not authorized without cookie' do
        run_test!
      end
    end
  end

  path '/api/v1/opportunities/{id}' do
    # TODO: we don't have a path to fetch one opp?
    # get 'Get one opportunity' do
    #   tags 'Opportunity'
    #   produces 'application/json'
    #   security [apiToken: []]
    #
    #   parameter name: :id, in: :path, type: :string
    #
    #   opportunity = FactoryBot.create :opportunity
    #   let(:id) { opportunity.id }
    #
    #   response '200', 'opportunity found' do
    #     let(:oxa_dev) { oxa_dev_cookie }
    #     # run_test!
    #     pending('SSO Auth not setup for testing')
    #   end
    #
    #   response '401', 'not authorized without cookie' do
    #     run_test!
    #   end
    # end

    patch 'Update an opportunity' do
      tags 'Opportunity'
      consumes 'application/json'
      produces 'application/json'
      security [apiToken: []]

      parameter name: :id, in: :path, type: :string

      parameter name: :opportunity_data, in: :body, schema: {
        salesforce_id: { type: :string },
        term_year: { type: :string },
        book_name: { type: :string },
        contact_id: { type: :string },
        new: { type: :boolean },
        close_date: { type: :string },
        number_of_students: { type: :string },
        class_start_date: { type: :string },
        school_id: { type: :string },
        book_id: { type: :string },
        name: { type: :string },
        stage_name: { type: :string }
      }

      opportunity = FactoryBot.create :opportunity
      let(:id) { opportunity.id }
      let(:opportunity_data) { }
      let(:oxa_dev) { oxa_dev_cookie }

      response '202', 'opportunity updated' do
        # run_test!
        pending('SSO Auth not setup for testing')
      end

      response '401', 'not authorized without cookie' do
        run_test!
      end
    end
  end
end
