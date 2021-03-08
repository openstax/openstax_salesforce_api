class Api::V1::UsersController < Api::V1::BaseController
  before_action -> { verify_sso_cookie }

  def index
    sso_cookie = cookie_data
    return return_bad_request('User') if sso_cookie.blank?

    opportunities = Opportunity.where(os_accounts_id: sso_cookie_field('id'))
    contact = Contact.find_by(salesforce_id: sso_cookie_field('salesforce_contact_id'))
    leads = Lead.where(os_accounts_id: sso_cookie_field('id'))
    list_subscriptions = contact.list_subscriptions unless contact.nil?

    render json: {
      opportunity: opportunities,
      contact: contact,
      lead: leads,
      subscriptions: list_subscriptions
    }
  end

end
