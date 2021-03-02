require 'rails_helper'
require 'swagger_helper'
require 'vcr_helper'

RSpec.describe 'api/v1/lists', type: :request, vcr: VCR_OPTS do
  before(:all) do
    @list = FactoryBot.create :list

    VCR.use_cassette('Pardot/lists.yml', VCR_OPTS) do
      OpenstaxSalesforceApi::Application.load_tasks
      Rake::Task['pardot:update_lists'].invoke
    end
  end

  path '/api/v1/lists' do
    get 'Retrieve all public mailing lists' do
      tags 'Lists'
      consumes 'application/json'
      parameter name: :list, in: :body, schema: {
        type: :object,
        properties: {
          pardot_id: { type: :string },
          title: { type: :string },
          description: { type: :string },
          created_at: { type: :string },
          updated_at: { type: :string }
        }
      }
      response '200', 'lists retrieved' do
        let(:list) { @list }
        run_test!
      end
    end
  end
end
