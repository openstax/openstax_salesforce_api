class SyncSalesforceOpportunitiesJob < ApplicationJob
  queue_as :opportunities
  sidekiq_options lock: :while_executing,
                  on_conflict: :reject

  def perform(uuid=nil)
    if uuid
      sf_opportunities = OpenStax::Salesforce::Remote::Opportunity.where(accounts_uuid:uuid)
    else
      # TODO: change this to use the fetched ID from Opportunity model
      sf_opportunities = OpenStax::Salesforce::Remote::Opportunity.where(record_type_name: 'Book Opp')
    end

    processed += 1
    total processed

    sf_opportunities.each do |sf_opportunity|
      Opportunity.cache_local(sf_opportunity)
      processed += 1
      at processed, "#{processed} processed"
    end
    JobsHelper.delete_objects_not_in_salesforce('Opportunity', sf_opportunities)
  end
end

if Sidekiq.server?
  Sidekiq::Cron::Job.create(name: 'Salesforce opportunities sync - every 1 hour', cron: '30 */1 * * *', class: 'SyncSalesforceOpportunitiesJob')
end
