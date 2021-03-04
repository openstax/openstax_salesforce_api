class SubscribeToListJob < ApplicationJob
  queue_as :default

  def perform(subscription_id)
    @client = Pardot.client
    subscription = Subscription.find(subscription_id)

    prospect_id = salesforce_to_prospect(subscription.contact.salesforce_id)

    begin
      @client.list_memberships.create(subscription.list.pardot_id, prospect_id)
      subscription.status = 'complete'
    rescue Pardot::ResponseError
      Rails.logger.info "#{subscription.contact.salesforce_id} already subscribed to list #{subscription.list.pardot_id}."
    end
  end

  def salesforce_to_prospect(salesforce_id)
    @client.prospects.read_by_fid(salesforce_id)['id']
  end
end
