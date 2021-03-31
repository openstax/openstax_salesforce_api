class Api::V1::BaseController < ApplicationController
  before_action :authorized_for_api

  include RescueFromUnlessLocal

  rescue_from_unless_local CannotFindUserContact, send_to_sentry: false do |ex|
    render json: { error: 'Cannot find Salesforce User' }, status: :not_found
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
    render json: { error: ex.message }, status: :not_found
  end

  protected

  def current_accounts_user
    @current_accounts_user ||= JSON.parse(OpenStax::Accounts::Api.search_accounts("uuid:#{sso_cookie_field('uuid')}", options = {}).body)['items'][0]
  end

  def current_contact
    @current_contact ||= begin
      raise(CannotFindUserContact) if current_accounts_user.blank?
      Contact.find_by(salesforce_id: current_accounts_user['salesforce_contact_id'])
    end
  end

  def current_contact!
    current_contact || raise(CannotFindUserContact)
  end
end
