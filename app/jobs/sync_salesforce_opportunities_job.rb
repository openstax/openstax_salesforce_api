class SyncSalesforceOpportunitiesJob < ApplicationJob
  queue_as :opportunities
  sidekiq_options lock: :while_executing,
                  on_conflict: :reject

  def perform(uuid=nil)
    if uuid
      sf_opportunities = OpenStax::Salesforce::Remote::Opportunity.where(accounts_uuid:uuid)
    else
      sf_opportunities = OpenStax::Salesforce::Remote::Opportunity.where(record_type_name:'Book Opp')
    end

    sf_opportunities.each do |sf_opportunity|
      opportunity = Opportunity.cache_opportunity(sf_opportunity)
      return opportunity if sf_opportunities.count == 1
    end
    JobsHelper.delete_objects_not_in_salesforce('Opportunity', sf_opportunities)
  end
end

# if Sidekiq.server?
#   Sidekiq::Cron::Job.create(name: 'Salesforce opportunities sync - every 1 hour', cron: '30 */1 * * *', class: 'SyncSalesforceOpportunitiesJob')
# end
