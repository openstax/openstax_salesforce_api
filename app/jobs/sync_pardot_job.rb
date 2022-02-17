class SyncPardotJob < ApplicationJob
  queue_as :pardot

  def perform(salesforce_ids = [])
    # we don't have pardot setup on all sandboxes, we don't need to try syncing without a business id set
    if Rails.application.secrets.pardot[:business_unit_id]
      store failure_state: 'Pardot business unit not set'
      return
    end

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

    # next, we create local records for the users subscriptions
    # without an argument, this processes all contacts - else you can specify an array of salesforce_ids to process
    query = salesforce_ids.empty? ? Contact.all : Contact.where(salesforce_id: salesforce_ids)

    # find_each processes the large amount of contacts in batches of 1000
    query.find_each do |contact|
      existing_subscriptions = Subscription.includes(:list).where(contact: contact)
      new_subscriptions = []

      # check Pardot for the prospect by salesforce_id, if it doesn't exist move to the next one
      begin
        prospect = Pardot.client.prospects.read_by_fid(contact.salesforce_id)
      rescue Pardot::ResponseError => e
        case e.message
        when 'Invalid prospect fid'
          next
        end
      end

      next unless prospect['lists'] # no lists on prospect == no subscriptions

      prospect['lists']['list_subscription'].each do |list_subscription|
        next unless list_subscription.include?('list')

        # Returns an array if it only has one subscription, but a hash otherwise. O_o This seems to handle it nicely.
        list_subscription = if list_subscription.is_a?(Array)
                              list_subscription[1]
                            else
                              list_subscription['list']
                            end

        next unless list_subscription['is_public'] == 'true' # we only care about public mailing lists

        new_subscriptions.append(list_subscription['id'].to_i) # append id to list so we can remove them below
        Subscription.where(list: List.find_by!(pardot_id: list_subscription['id']), contact: contact).first_or_create
      end

      # remove local subscription records that no longer exist in pardot
      # these might have been updated from the email preferences link or in pardot itself
      existing_subscriptions.each do |existing_subscription|
        existing_subscription.destroy unless new_subscriptions.include?(existing_subscription.list.pardot_id)
      end
    end
  end
end

if Sidekiq.server?
  Sidekiq::Cron::Job.create(name: 'Pardot sync - every 3 hours', cron: '55 */3 * * *', class: 'SyncPardotJob')
end
