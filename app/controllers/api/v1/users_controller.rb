class Api::V1::UsersController < Api::V1::BaseController
  def index
    opportunities = Opportunity.where(accounts_uuid: @current_accounts_user['uuid'])
    leads = Lead.where(accounts_uuid: @current_accounts_user['uuid'])
    contact = current_contact
    if contact
      schools = AccountContactRelation.where(contact_id: contact&.salesforce_id)
      subscriptions = contact&.subscriptions
    end

    render json: {
      opportunity: opportunities,
      contact: contact,
      schools: schools,
      lead: leads,
      subscriptions: subscriptions
    }
  end
end
