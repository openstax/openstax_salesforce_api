class Api::V1::BaseController < ApplicationController
  before_action :authorized_for_api?
  protect_from_forgery with: :null_session

  include RescueFromUnlessLocal

  rescue_from_unless_local CannotFindUserContact, send_to_sentry: false do |ex|
    render json: { error: 'Cannot find Salesforce User' }, status: :not_found
  end

  rescue_from_unless_local NoSSOCookieSet, send_to_sentry: false do |ex|
    render json: { error: 'No SSO Cookie Set' }, status: :not_found
  end

  rescue_from_unless_local CannotFindProspect, send_to_sentry: false do |ex|
    render json: { error: 'Cannot find Pardot prospect with that Salesforce ID' }, status: :not_found
  end

  rescue_from_unless_local BadRequest, send_to_sentry: true do |ex|
    render json: { error: ex.message }, status: :bad_request
  end

  rescue_from_unless_local NotAuthorized do |ex|
    render json: { error: ex.message }, status: :unauthorized
  end

  rescue_from_unless_local ActiveRecord::RecordNotFound, send_to_sentry: false do |ex|
    Sentry.capture_exception(ex) if ex.model == 'School'
    render json: { error: ex.message }, status: :not_found
  end

  protected

  def current_api_user
    raise NoSSOCookieSet unless current_api_user
    User.new(current_sso_user_uuid)
  end
end
