require 'openstax/auth/strategy_2'

class ApplicationController < ActionController::API
  USE_SSO = Rails.configuration.sso['use_sso'].freeze

  def verify_sso_cookie(sf_object)
    return unless USE_SSO

    decrypt = OpenStax::Auth::Strategy2.decrypt(request)
    cookie_id = decrypt.dig('sub', 'salesforce_contact_id')
    contact = Contact.where(salesforce_id: cookie_id)
    return_bad_request(sf_object) if contact.blank?
  end

  def cookie_data
    return unless USE_SSO

    OpenStax::Auth::Strategy2.decrypt(request)
  end

  def return_bad_request(sf_object)
    render json: { request_object: sf_object.to_s, status: 'bad request' }.to_json, status: :bad_request
  end
end
