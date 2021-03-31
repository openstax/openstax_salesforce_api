class SyncPardotJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 2

  def perform(salesforce_ids = [])
    # first, let's update the lists from Pardot
    existing_lists = List.pluck(:pardot_id)
    new_lists = []

    lists = Pardot.client.lists.query(is_greater_than: 0)
    lists['list'].each do |list|
      next unless list['is_public'] == 'true'

      new_lists.append(list['id'].to_i)
      @pardot_list = List.where(pardot_id: list['id']).first_or_create do |plist|
        plist.title = list['title']
        plist.description = list['description']
      end
    end

    # remove lists if they no longer exist in Pardot
    existing_lists.each do |existing_list_pardot_id|
      List.destroy_by(pardot_id: existing_list_pardot_id) unless new_lists.include? existing_list_pardot_id
    end

    # without an argument, this processes all contacts - else you can specify an array of salesforce_ids to process
    query = salesforce_ids.empty? ? Contact.all : Contact.where(salesforce_id: salesforce_ids)

    # find_each processes the large amount of contacts in batches of 1000
    query.find_each do |contact|
      existing_subscriptions = Subscription.includes(:list).where(contact: contact)
      new_subscriptions = []

      prospect = Pardot.client.prospects.read_by_fid(contact.salesforce_id)
      next unless prospect['lists']

      prospect['lists']['list_subscription'].each do |list|
        if list.include?('list')
          # Returns an array if it only has one subscription, but a hash otherwise. O_o This seems to handle it nicely.
          list = if list.is_a?(Array)
                   list[1]
                 else
                   list['list']
                 end

          next unless list['is_public'] == 'true'

          new_subscriptions.append(list['id'].to_i)
          Subscription.where(list: List.where(pardot_id: list['id']), contact: contact).first_or_create
        end
      rescue Pardot::ResponseError
        Rails.logger.info 'No Pardot record for contact: ' + contact.salesforce_id
      end

      # remove local subscription records that no longer exist in pardot
      # these might have been updated from the email preferences link or in pardot itself
      existing_subscriptions.each do |existing_subscription|
        existing_subscription.destroy unless new_subscriptions.include?(existing_subscription.list.pardot_id)
      end
    end
  end
end
