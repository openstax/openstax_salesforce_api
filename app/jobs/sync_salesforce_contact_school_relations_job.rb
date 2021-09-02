class SyncSalesforceContactSchoolRelationsJob < ApplicationJob
  queue_as :default

  def perform(contact_id=nil)
    last_id = nil
    loop do
      if contact_id
        sf_relations = OpenStax::Salesforce::Remote::AccountContactRelation.where(contact_id:contact_id)
      else
        sf_relations = OpenStax::Salesforce::Remote::AccountContactRelation.order(:id).limit(BATCH_SIZE)
      end
      sf_relations = sf_relations.where("id > '#{last_id}'") unless last_id.nil?
      sf_relations = sf_relations.to_a
      last_id = sf_relations.last.id unless sf_relations.last.nil?

      sf_relations.each do |sf_relation|
        relation_to_update = AccountContactRelation.find_or_initialize_by(contact_id: sf_relation.contact_id, school_id: sf_relation.school_id)
        relation_to_update.salesforce_id = sf_relation.id
        relation_to_update.contact_id = sf_relation.contact_id
        relation_to_update.school_id = sf_relation.school_id
        relation_to_update.primary = sf_relation.primary
        relation_to_update.save if relation_to_update.changed?
      end
      break if sf_relations.length < BATCH_SIZE
    end
    delete_objects_not_in_salesforce('AccountContactRelation')
  end
end

if Sidekiq.server?
  Sidekiq::Cron::Job.create(name: 'Salesforce contact school relation sync - every 3 hours', cron: '0 */3 * * *', class: 'SyncSalesforceContactSchoolRelationsJob')
end
