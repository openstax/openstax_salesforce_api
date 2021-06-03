class Api::V1::UsersController < Api::V1::BaseController
  def index
    opportunities = Opportunity.where(os_accounts_id: sso_cookie_field('id'))
    leads = Lead.where(os_accounts_id: sso_cookie_field('id'))
    schools = AccountContactRelation.find_by(contact_id: current_contact&.id)

    render json: {
      opportunity: opportunities,
      contact: current_contact,
      schools: schools,
      lead: leads,
      subscriptions: current_contact&.subscriptions
    }
  end
end
