class SyncPardotProspectsAndSubscriptionsJob < ApplicationJob
  queue_as :large_jobs
  sidekiq_options retry: 2

  def perform()
    Contact.all.each do |contact|
      prospect = Pardot.client.prospects.read_by_fid(salesforce_id)

      prospect['lists']['list_subscription'].each do |subscription|
        next unless subscription['list']['is_public'] == 'true'

        list = List.where(pardot_id: subscription['list']['id']).first_or_create do |plist|
          plist.title = subscription['list']['title']
          plist.description = subscription['list']['description']
        end

        Subscription.create list: list, contact: contact
      rescue TypeError => e
        puts e
      rescue Pardot::ResponseError
        Rails.logger.info 'No Pardot record for contact: ' + salesforce_id
      end
    end
  end
end
