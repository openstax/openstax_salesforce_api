class SyncSalesforceContactSchoolRelationsJob < ApplicationJob
  queue_as :schools
  sidekiq_options lock: :while_executing,
                  on_conflict: :reject

  def perform(contact_id=nil)
    if contact_id
      sf_relations = OpenStax::Salesforce::Remote::AccountContactRelation.where(contact_id:contact_id)
    else
      sf_relations = OpenStax::Salesforce::Remote::AccountContactRelation.all
    end

    sf_relations.each do |sf_relation|
      relation = AccountContactRelation.cache_local(sf_relation)

      return relation if sf_relations.count == 1
    end
    JobsHelper.delete_objects_not_in_salesforce('AccountContactRelation', sf_relations)
  end
end

if Sidekiq.server?
  Sidekiq::Cron::Job.create(name: 'Salesforce contact school relation sync - every 3 hours', cron: '45 */3 * * *', class: 'SyncSalesforceContactSchoolRelationsJob')
end
