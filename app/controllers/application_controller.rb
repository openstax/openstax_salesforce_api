require 'openstax/auth/strategy_2'

class ApplicationController < ActionController::Base
  USE_SSO = Rails.configuration.sso['use_sso'].freeze

  def verify_sso_cookie(sf_object)
    return unless USE_SSO

    cookie_uuid = cookie_data.dig('sub', 'uuid')
    if cookie_uuid.blank?
      doorkeeper_authorize!
    end
  end

  def cookie_data
    unless USE_SSO
      return
    end

    OpenStax::Auth::Strategy2.decrypt(request)
  end

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { error: "Not authorized" } }
  end
end
