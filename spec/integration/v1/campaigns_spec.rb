require 'swagger_helper'

RSpec.describe 'api/v1/campaigns', type: :request do
  path '/api/v1/campaigns' do
    get 'List all Campaigns' do
      tags 'Campaigns'
      consumes 'application/json'
      parameter name: :campaign, in: :body, schema: {
        type: :object,
        properties: {
          salesforce_id: { type: :string },
          name: { type: :string },
          is_active: { type: :boolean },
          created_at: { type: :datetime },
          updated_at: { type: :datetime }
        },
        required: %w[salesforce_id name]
      }
      response '200', 'campaigns retrieved' do
        let(:campaign) { FactoryBot.create :campaign }
        run_test!
      end
    end
  end

  path '/api/v1/campaigns/{id}' do

    get 'Return one campaign' do
      tags 'Campaigns'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'campaign found' do
        schema type: :object,
               properties: {
                 salesforce_id: { type: :string },
                 name: { type: :string },
                 is_active: { type: :boolean },
                 created_at: { type: :datetime },
                 updated_at: { type: :datetime }
               },
               required: %w[salesforce_id name]

        let(:id) { Campaign.create(name: 'Test Campaign', salesforce_id: 'AZ44335AQ').id }
        run_test!
      end

      response '404', 'campaign not found' do
        let(:id) { 25 }
        run_test!
      end
    end
  end
end