require 'openstax/auth/strategy_2'

class ApplicationController < ActionController::Base

  def doorkeeper_unauthorized_render_options(error: nil)
    raise NotAuthorized
  end

  protected

  def authorized_for_api
    # this bypasses using the sso cookie or doorkeeper for local development
    # comment this line out to use production-like auth in development
    # which will require a local accounts install for setting the cookie
    return if Rails.env.development?
    return unless sso_cookie_field('uuid').blank?

    doorkeeper_authorize!
  end

  def sso_cookie
    @sso_cookie ||= OpenStax::Auth::Strategy2.decrypt(request)
  end

  def sso_cookie_field(field_name)
    sso_cookie&.dig('sub', field_name)
  end
end
