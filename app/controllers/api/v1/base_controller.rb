class Api::V1::BaseController < ApplicationController
  before_action :verify_sso_cookie

  include RescueFromUnlessLocal

  rescue_from_unless_local StandardError, send_to_sentry: true do |ex|
    render json: { error: ex.message }, status: 500
  end

  rescue_from_unless_local CannotFindUserContact, send_to_sentry: true do |ex|
    render json: { error: 'Cannot find Salesforce User' }, status: 404
  end

  rescue_from_unless_local BadRequest, send_to_sentry: true do |ex|
    render json: { error: 'Bad request' }, status: :bad_request
  end

  rescue_from NotAuthorized do |ex|
    head :unauthorized
  end
end
