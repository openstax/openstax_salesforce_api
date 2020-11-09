require 'openstax/auth/strategy_2'

class ApplicationController < ActionController::API
  ALLOWED_APIS = ['Opportunity']
  USE_SSO = Rails.configuration.sso['use_sso']

  def verify_sso_cookie(sf_object, os_user_id)
    unless USE_SSO
      return
    end

    if ALLOWED_APIS.include? sf_object
      decrypt = OpenStax::Auth::Strategy2.decrypt(request)
      cookie_id = decrypt.dig('sub', 'id')
      unless cookie_id == os_user_id.to_i
        return_bad_request(sf_object)
      end
    else
      return_bad_request(sf_object)
    end
  end

  def return_bad_request(sf_object)
    render json: {
        request_object: sf_object, status: :bad_request
    }
  end
end
