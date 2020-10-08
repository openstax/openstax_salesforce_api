require 'swagger_helper'
require 'spec_helper'

RSpec.describe 'api/v1/campaigns', type: :request do

  before(:all) do
    @campaign = FactoryBot.create :api_campaign
    request_header = request_header_with_token
    @token = request_header['Authorization']
  end

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
          created_at: { type: :string },
          updated_at: { type: :string }
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
      response '200', 'campaigns retrieved' do
        let(:campaign) { @campaign }
        let(:Authorization) { @token }
        run_test!
      end
    end
  end

  path '/api/v1/campaigns/{id}' do

    get 'Return one campaign' do
      tags 'Campaigns'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter({
          :in => :header,
          :type => :string,
          :name => :Authorization,
          :required => true,
          :description => 'Client token'
      })

      response '200', 'campaign found' do
        schema type: :object,
               properties: {
                 salesforce_id: { type: :string },
                 name: { type: :string },
                 is_active: { type: :boolean },
                 created_at: { type: :string },
                 updated_at: { type: :string }
               },
               required: %w[salesforce_id name]

        let(:id) { @campaign.id }
        let(:Authorization) { @token }
        run_test!
      end

      response '404', 'campaign not found' do
        let(:id) { 'invalid' }
        let(:Authorization) { @token }
        run_test!
      end
    end
  end
end
