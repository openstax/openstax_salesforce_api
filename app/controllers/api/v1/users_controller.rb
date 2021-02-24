class Api::V1::UsersController < ApplicationController
  def index
    sso_cookie = cookie_data
    return return_bad_request('User') if sso_cookie.blank?

    # get opportunity
    opportunity = Opportunity.where(os_accounts_id: sso_cookie.dig('sub', 'id'))
    # get contact
    contact = Contact.where(salesforce_id: sso_cookie.dig('sub', 'salesforce_contact_id'))
    # get leads
    lead = Lead.where(os_accounts_id: sso_cookie.dig('sub', 'id'))


    render json: {
      opportunity: opportunity,
      contact: contact,
      lead: lead,
      subscriptions: contact.list_subscriptions
    }
  end

end
