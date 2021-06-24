require 'swagger_helper'
require 'rails_helper'
require 'vcr_helper'
require 'spec_helper'

RSpec.describe 'api/v1/opportunities', type: :request, vcr: VCR_OPTS do
  before do
    allow(Rails.application.config).to receive(:consider_all_requests_local) { true }
  end

  before(:all) do
    @opportunity = FactoryBot.create :api_opportunity
    # needed for cookie check
    contact = create_contact
    @headers = set_cookie
    @token_header = create_token_header
    opportunity = FactoryBot.create(:api_opportunity, {:salesforce_id=>'0062F00000BG056QAD',:contact_id=>'0032F00000cfZQhQAM', :school_id=>'0012F00000iPxe9QAC'})
    VCR.use_cassette('OpportunitiesController/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  path '/api/v1/opportunities' do
    get 'List all Opportunities' do
      tags 'Opportunities'
      consumes 'application/json'
      security [apiToken: []]

      parameter name: :opportunity, in: :body, schema: {
        type: :object,
        properties: {
          salesforce_id: { type: :string },
          term_year: { type: :string },
          book_name: { type: :string },
          contact_id: { type: :string },
          new: { type: :boolean },
          close_date: { type: :string },
          stage_name: { type: :string },
          update_type: { type: :string },
          number_of_students: { type: :string },
          student_number_status: { type: :string },
          time_period: { type: :string },
          class_start_date: { type: :string },
          school_id: { type: :string },
          book_id: { type: :string },
          lead_source: { type: :string },
          salesforce_updated: { type: :string },
          os_accounts_id: { type: :string },
          name: { type: :string },
          created_at: { type: :string },
          updated_at: { type: :string }
        },
        required: %w[salesforce_id contact_id school_id]
      }
      response '200', 'opportunities retrieved' do
        let(:opportunity) { @opportunity }
        let(:HTTP_COOKIE) { oxa_cookie }

        run_test!
      end

      response '401', 'no cookie' do
        let(:opportunity) { @opportunity }
        let(:HTTP_COOKIE) {}

        run_test!
      end
    end

  end

  path '/api/v1/opportunities/search' do
    get 'Return opportunity by account id' do
      tags 'Opportunity'
      consumes 'application/json'
      security [apiToken: []]

      parameter name: :os_accounts_id, in: :query, type: :string

      response '200', 'opportunity found' do

        let(:os_accounts_id) { @opportunity.os_accounts_id.to_s }
        let(:HTTP_COOKIE) { oxa_cookie }

        run_test!
      end
    end
  end

end
