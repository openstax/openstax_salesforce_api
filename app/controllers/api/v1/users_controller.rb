class Api::V1::UsersController < Api::V1::BaseController
  def index
    accounts_uuid = current_accounts_user!['uuid']
    opportunities = Opportunity.where(accounts_uuid: accounts_uuid)
    leads = Lead.where(accounts_uuid: accounts_uuid)
    if contact = current_contact
      schools = AccountContactRelation.where(contact_id: contact&.salesforce_id)
      subscriptions = contact&.subscriptions
    end

    render json: {
      opportunity: opportunities,
      contact: current_contact,
      schools: schools,
      lead: leads,
      subscriptions: subscriptions
    }
  end
end
