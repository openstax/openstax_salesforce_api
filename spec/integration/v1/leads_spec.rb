require 'swagger_helper'
require 'rails_helper'
#require 'vcr_helper'
require 'spec_helper'

RSpec.describe 'api/v1/leads', type: :request do
  before do
    allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
  end

  before(:all) do
    # needed for cookie check
    contact = create_contact
    @headers = set_cookie
    @token_header = create_token_header
    #@lead = FactoryBot.create(:api_lead, { salesforce_id: '0062F00000BG056QAD', contact_id: '0032F00000cfZQhQAM', school_id: '0012F00000iPxe9QAC' })
    # VCR.use_cassette('LeadsIntegration/sf_setup', VCR_OPTS) do
    #   @proxy = SalesforceProxy.new
    #   @proxy.setup_cassette
    # end
  end

  path '/api/v1/leads' do

    post 'Create a lead' do
      tags 'Lead'
      consumes 'application/json'
      security [apiToken: []]

      parameter name: :lead_data, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          first_name: { type: :string },
          last_name: { type: :string },
          salutation: { type: :string },
          subject: { type: :string },
          school: { type: :string },
          phone: { type: :string },
          website: { type: :string },
          status: { type: :string },
          email: { type: :string },
          source: { type: :string },
          newsletter: { type: :boolean },
          newsletter_opt_in: { type: :boolean },
          adoption_status: { type: :string },
          num_students: { type: :integer },
          os_accounts_id: { type: :integer },
          accounts_uuid: { type: :string },
          application_source: { type: :string },
        },
        #required: %w[book_name contact_id close_date number_of_students school_id stage_name]
      }

      response '202', 'lead created' do

        let(:lead_data) do
          {
            'salesforce_id': 'new lead',
            'first_name': "Houston",
            'last_name': "Hayes",
            'salutation': "DO",
            'subject': "psychology",
            'school': "South New York Academy",
            'phone': "(646) 410-5464",
            'website': "http://example.com/yetta.wilderman",
            'status': "Needs School",
            'email': "les.hudson@example.com",
            'source': "Chat",
            'newsletter': "f",
            'newsletter_opt_in': "f",
            'adoption_status': "Confirmed Adoption Won",
            'num_students': 263,
            'os_accounts_id': "6564010917",
            'accounts_uuid': "a9711bf4-8803-4899-86a5-398afa507401",
            'application_source': "OS Web",
            'role': "faculty",
            'who_chooses_books': "instructor",
            'verification_status': "rejected_faculty",
            'finalize_educator_signup': true
          }
        end
        let(:HTTP_COOKIE) { oxa_cookie }

        run_test!
      end
    end

  end
end
