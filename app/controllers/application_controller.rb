require 'openstax/auth/strategy_2'

class ApplicationController < ActionController::Base
  USE_SSO = Rails.configuration.sso['use_sso'].freeze

  def verify_sso_cookie(sf_object)
    return unless USE_SSO

    decrypt = OpenStax::Auth::Strategy2.decrypt(request)
    cookie_id = decrypt.dig('sub', 'salesforce_contact_id')
    if cookie_id.blank?
      doorkeeper_authorize!
    else
      contact = Contact.where(salesforce_id: cookie_id)
      if contact.blank?
        return_bad_request(sf_object) unless doorkeeper_token
      end
    end
  end

  def cookie_data
    return unless USE_SSO

    OpenStax::Auth::Strategy2.decrypt(request)
  end

  def return_bad_request(object)
    render json: { request_object: object.to_s, status: 'bad request' }.to_json, status: :bad_request
  end

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { error: "Not authorized" } }
  end
end
