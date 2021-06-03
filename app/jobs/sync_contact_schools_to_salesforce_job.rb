class SyncContactSchoolsToSalesforceJob < ApplicationJob
  queue_as :default

  def perform(relation)
    #TODO: need to handle deletes
    sf_relation = OpenStax::Salesforce::Remote::AccountContactRelation.new(
      contact_id: relation.contact_id,
      school_id: relation.school_id
    )
    sf_relation.save!
  end
end
