class SyncSalesforceContactsJob < ApplicationJob
  queue_as :contacts
  sidekiq_options lock: :while_executing,
                  on_conflict: :reject

  def perform(uuid=nil)
    if uuid
      sf_contacts = OpenStax::Salesforce::Remote::Contact.where(accounts_uuid:uuid)
    else
      sf_contacts = OpenStax::Salesforce::Remote::Contact.all
    end

    total sf_contacts.count
    processed = 0

    sf_contacts.each do |sf_contact|
      Contact.cache_local(sf_contact)
      processed += 1
      at processed, "#{processed} processed"
    end
    JobsHelper.delete_objects_not_in_salesforce('Contact', sf_contacts)
  end
end

if Sidekiq.server?
  Sidekiq::Cron::Job.create(name: 'Salesforce contact sync - every 30 min', cron: '0 */1 * * *', class: 'SyncSalesforceContactsJob')
end
