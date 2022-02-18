require 'rails_helper'

RSpec.describe 'api/users', type: :request do
  path "/api/v1/users" do
    get "Returns a user" do
      tags "Users"
      produces "application/json"
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          ox_uuid: { type: :string },
          opportunities: { type: :array },
          contact: { type: :array },
          schools: { type: :array },
          leads: { type: :array },
          subscriptions: { type: :array }
        },
        required: ["ox_uuid", ],
      }
      response "200", "user retrieved" do
        let(:oxa_dev) { oxa_dev_cookie }
        # run_test!
        pending('SSO Auth not setup for testing')
      end

      response "401", "not authorized without cookie" do
        run_test!
      end
    end
  end
end
