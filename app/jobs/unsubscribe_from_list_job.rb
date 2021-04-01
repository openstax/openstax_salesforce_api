class UnsubscribeFromListJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 5

  def perform(subscription)
    return unless prospect_id = Pardot.salesforce_to_prospect(subscription.contact.salesforce_id)

    Pardot.client.list_memberships.delete(subscription.list.pardot_id, prospect_id)

    # destroy the subscription record but if that fails, recreate it in Pardot
    Pardot.client.list_memberships.create(subscription.list.pardot_id, prospect_id) unless subscription.destroy
  end
end
