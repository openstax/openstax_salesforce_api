require 'openstax/auth/strategy_2'

class ApplicationController < ActionController::Base
  USE_SSO = Rails.configuration.sso['use_sso'].freeze

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { error: 'Not authorized' } }
  end

  protected

  def verify_sso_cookie
    return unless USE_SSO

    cookie_id = sso_cookie_field('salesforce_contact_id')
    if cookie_id.blank?
      doorkeeper_authorize!
    else
      contact = Contact.where(salesforce_id: cookie_id)
      if contact.blank?
        return_bad_request unless doorkeeper_token
      end
    end
  end

  def cookie_data
    return unless USE_SSO

    @cookie_data ||= OpenStax::Auth::Strategy2.decrypt(request)
  end

  def sso_cookie_field(field_name)
    cookie_data.dig('sub', field_name)
  rescue NoMethodError
    nil
  end

  def return_bad_request
    raise BadRequest
  end

end
