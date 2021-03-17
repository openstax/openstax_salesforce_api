class Api::V1::UsersController < ApplicationController

  def index
    sso_cookie = cookie_data
    render json: { status: 'bad request' }.to_json, status: :bad_request and return if sso_cookie.blank?

    opportunity = Opportunity.where(os_accounts_id: sso_cookie.dig('sub', 'id'))
    cookie_uuid = sso_cookie.dig('sub', 'uuid')
    results = JSON.parse(OpenStax::Accounts::Api.search_accounts("uuid:#{cookie_uuid}", options = {}).body)
    contact_id = results['items'][0]['salesforce_contact_id'] unless results['items'].blank?
    contact = Contact.where(salesforce_id: contact_id)
    lead = Lead.where(os_accounts_id: sso_cookie.dig('sub', 'id'))

    render json: {
      opportunity: opportunity,
      contact: contact,
      lead: lead
    }
  end
end
