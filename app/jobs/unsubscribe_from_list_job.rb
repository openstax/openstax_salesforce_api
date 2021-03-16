class UnsubscribeFromListJob < ApplicationJob
  queue_as :default

  def perform(subscription)
    return unless prospect_id = Pardot.salesforce_to_prospect(subscription.contact.salesforce_id)

    Pardot.client.list_memberships.delete(subscription.list.pardot_id, prospect_id)
    subscription.destroy
  end
end
