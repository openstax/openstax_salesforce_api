require 'swagger_helper'
require 'rails_helper'
require 'vcr_helper'
require 'spec_helper'

RSpec.describe 'api/v1/opportunities', type: :request, vcr: VCR_OPTS do
  before do
    allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
  end

  before(:all) do
    # needed for cookie check
    contact = create_contact
    @headers = set_cookie
    @token_header = create_token_header
    @opportunity = FactoryBot.create(:api_opportunity, { salesforce_id: '0062F00000BG056QAD', contact_id: '0032F00000cfZQhQAM', school_id: '0012F00000iPxe9QAC' })
    #@book = Book.new(salesforce_id: 'a0Z7h000001a79WEAQ', name: 'College Algebra')
    @book = FactoryBot.create(:api_book, {salesforce_id: 'a0Z7h000001a79WEAQ', name: 'College Algebra'})
    VCR.use_cassette('OpportunitiesIntegration/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  path '/api/v1/opportunities' do

    post 'Create an opportunity' do
      tags 'Opportunity'
      consumes 'application/json'
      security [apiToken: []]

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

      response '202', 'opportunity created' do

        let(:opportunity_data) do
          {
            'contact_id': '0037h00000SDIPmAAP',
            'close_date': DateTime.now.strftime('%Y-%m-%d'),
            'number_of_students': 123,
            'class_start_date': DateTime.now.strftime('%Y-%m-%d'),
            'school_id': '0017h00000YMwc1AAD',
            'book_name': 'College Algebra'
          }
        end
        let(:HTTP_COOKIE) { oxa_cookie }

        run_test!
      end
    end

  end

  # path '/api/v1/opportunities/search' do
  #   get 'Return opportunity by account id' do
  #     tags 'Opportunity'
  #     consumes 'application/json'
  #     security [apiToken: []]
  #
  #     parameter name: :os_accounts_id, in: :query, type: :string
  #
  #     response '200', 'opportunity found' do
  #
  #       let(:os_accounts_id) { @opportunity.os_accounts_id.to_s }
  #       let(:HTTP_COOKIE) { oxa_cookie }
  #
  #       run_test!
  #     end
  #   end
  # end
  #
  path '/api/v1/opportunities/{id}' do
  #   get 'Get one opportunity' do
  #     tags 'Opportunity'
  #     consumes 'application/json'
  #     produces 'application/json'
  #     security [apiToken: []]
  #
  #     parameter name: :id, in: :path, type: :string
  #
  #     response '200', 'opportunity found' do
  #       let(:id) { @opportunity.salesforce_id.to_s }
  #       let(:HTTP_COOKIE) { oxa_cookie }
  #
  #       run_test!
  #     end
  #   end

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

      response '202', 'opportunity updated' do
        let(:id) { @opportunity.salesforce_id.to_s }
        let(:opportunity_data) do
          {
            'number_of_students': 5678
          }
        end
        let(:HTTP_COOKIE) { oxa_cookie }

        run_test!
      end
    end
  end
end
