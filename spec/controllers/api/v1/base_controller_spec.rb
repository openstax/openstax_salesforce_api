require 'rails_helper'

RSpec.describe Api::V1::BaseController, type: :controller do
  controller do
    def standard_error
      raise StandardError
    end

    def cannot_find_user_contact
      raise CannotFindUserContact
    end

    def cannot_find_prospect
      raise CannotFindProspect
    end

    def bad_request
      raise BadRequest
    end

    def not_authorized
      raise NotAuthorized
    end
  end

  context 'in development' do
    before do
      allow(Rails.application.config).to receive(:consider_all_requests_local) { true }
    end

    it { expect_exception(:cannot_find_user_contact, CannotFindUserContact) }
    it { expect_exception(:not_authorized, NotAuthorized) }
    it { expect_exception(:cannot_find_prospect, CannotFindProspect) }
    it { expect_exception(:bad_request, BadRequest) }
    it { expect_exception(:standard_error, StandardError) }
  end

  context 'in production' do
    before do
      allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
    end

    it { expect_json(:cannot_find_user_contact, /Cannot find Salesforce User/, :not_found) }
    it { expect_json(:not_authorized, "NotAuthorized", :unauthorized) }
    it { expect_json(:cannot_find_prospect, /Cannot find Pardot prospect with that Salesforce ID/, :not_found) }
    it { expect_json(:bad_request, "BadRequest", :bad_request) }
  end

  def expect_exception(action, exception)
    routes.draw { get action.to_s => "api/v1/base##{action}" }

    request.headers.merge! set_cookie
    expect { get action }.to raise_error(exception)
  end

  def expect_json(action, message, status)
    routes.draw { get action.to_s => "api/v1/base##{action}" }

    request.headers.merge! set_cookie
    get action
    expect(response).to have_http_status(status)
    expect(response.body).to match(message)
  end
end
