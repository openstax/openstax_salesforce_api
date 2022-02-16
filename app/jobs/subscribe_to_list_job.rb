class SubscribeToListJob < ApplicationJob
  queue_as :pardot

  def perform(subscription)
    return unless (prospect_id = Pardot.salesforce_to_prospect(subscription.contact.salesforce_id))

    Pardot.client.list_memberships.create(subscription.list.pardot_id, prospect_id)
    subscription.created!
  end
end
