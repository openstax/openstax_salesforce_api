class Api::V1::UsersController < Api::V1::BaseController
  def index
    opportunities = Opportunity.where(os_accounts_id: sso_cookie_field('id'))
    leads = Lead.where(os_accounts_id: sso_cookie_field('id'))
    list_subscriptions = current_contact&.list_subscriptions

    render json: {
      opportunity: opportunities,
      contact: current_contact,
      lead: leads,
      subscriptions: list_subscriptions
    }
  end
end
