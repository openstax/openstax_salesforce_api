class SyncPardotProspectsAndSubscriptionsJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 2

  def perform(salesforce_ids = [])
    # without an argument, this processes all contacts - else you can specify an array of salesforce_ids to process
    query = Contact.all
    query = query.where(salesforce_id: salesforce_ids) unless salesforce_ids.empty?

    query.each do |contact|
      current_subscriptions = Subscription.includes(:list).where(contact: contact)
      new_subscriptions = []

      prospect = Pardot.client.prospects.read_by_fid(contact.salesforce_id)
      next unless prospect['lists']

      prospect['lists']['list_subscription'].each do |subscription|
        if subscription.include?('list')
          # Returns an array if it only has one subscription, but a hash otherwise. O_o This seems to handle it nicely.
          subscription = if subscription.is_a?(Array)
                           subscription[1]
                         else
                           subscription['list']
                         end

          next unless subscription['is_public'] == 'true'

          new_subscriptions.append(subscription['id'].to_i)
          list = List.where(pardot_id: subscription['id']).first_or_create do |plist|
            plist.title = subscription['title']
            plist.description = subscription['description']
          end

          Subscription.where(list: list, contact: contact).first_or_create
        end
      rescue Pardot::ResponseError
        Rails.logger.info 'No Pardot record for contact: ' + contact.salesforce_id
      end

      # remove lists user is no longer subscribed to
      current_subscriptions.each do |current_subscription|
        current_subscription.destroy unless new_subscriptions.include?(current_subscription.list.pardot_id)
      end
    end
  end
end
