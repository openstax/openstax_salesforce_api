class SyncSalesforceContactSchoolRelationsJob < ApplicationJob
  queue_as :default

  def perform(id=nil)
    if id
      sf_relations = OpenStax::Salesforce::Remote::AccountContactRelation.where(id:id)
    else
      sf_relations = OpenStax::Salesforce::Remote::AccountContactRelation.all
    end

    sf_relations.each do |sf_relation|
      relation_to_update = AccountContactRelation.find_or_initialize_by(contact_id: sf_relation.contact_id, school_id: sf_relation.school_id)
      relation_to_update.salesforce_id = sf_relation.id
      relation_to_update.contact_id = sf_relation.contact_id
      relation_to_update.school_id = sf_relation.school_id
      relation_to_update.primary = sf_relation.primary
      relation_to_update.save if relation_to_update.changed?
    end
  end
end

if Sidekiq.server?
  Sidekiq::Cron::Job.create(name: 'Salesforce contact school relation sync - every 30 min', cron: '*/30 * * * *', class: 'Sync_salesforceContactSchoolRelationsJob')
end
