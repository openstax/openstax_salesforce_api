class SyncSalesforceLeadsJob < ApplicationJob
  queue_as :leads
  sidekiq_options lock: :while_executing,
                  on_conflict: :reject

  def perform(uuid=nil)
    if uuid
      sf_leads = OpenStax::Salesforce::Remote::Lead.where(accounts_uuid:uuid)
    else
      sf_leads = OpenStax::Salesforce::Remote::Lead.all
    end

    total sf_leads.count
    processed = 0

    sf_leads.each do |sf_lead|
      Lead.cache_local(sf_lead)
      processed += 1
      total processed
    end
    JobsHelper.delete_objects_not_in_salesforce('Lead', sf_leads)
  end
end

# We don't need a cron to update leads yet - but when/if we do start using them...
# if Sidekiq.server?
#   Sidekiq::Cron::Job.create(name: 'Salesforce leads sync - every 1 hour', cron: '30 */1 * * *', class: 'SyncSalesforceLeadsJob')
# end
