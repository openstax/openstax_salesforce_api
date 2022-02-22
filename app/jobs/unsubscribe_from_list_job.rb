class UnsubscribeFromListJob < ApplicationJob
  queue_as :pardot

  def perform(subscription)
    if Rails.application.secrets.pardot[:business_unit_id]
      store failure_state: 'Pardot business unit not set'
      return
    end

    return unless prospect_id = Pardot.salesforce_to_prospect(subscription.contact.salesforce_id)

    Pardot.client.list_memberships.delete(subscription.list.pardot_id, prospect_id)
    subscription.destroy!
  end
end
