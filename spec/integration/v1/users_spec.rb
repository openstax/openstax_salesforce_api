require 'swagger_helper'
require 'rails_helper'
require 'spec_helper'
require 'vcr_helper'

RSpec.describe 'api/v1/users', type: :request, vcr: VCR_OPTS do

  before(:all) do
    @contact = create_contact
    @lead = FactoryBot.create :api_lead
    @opportunity = FactoryBot.create :api_lead
    VCR.use_cassette('UsersController/users', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  path '/api/v1/users' do
    get 'returns data for user in cookie' do
      tags 'Users'
      consumes 'application/json'
      security [apiToken: []]

      response '200', 'user data retrieved' do
        let(:HTTP_COOKIE) { oxa_cookie }

        run_test!
      end

      response '400', 'no cookie' do
        let(:HTTP_COOKIE) { }

        run_test!
      end
    end
  end
end
