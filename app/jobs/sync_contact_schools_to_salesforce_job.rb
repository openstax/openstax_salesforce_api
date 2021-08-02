class SyncContactSchoolsToSalesforceJob < ApplicationJob
  queue_as :default

  def perform(relation, action)
    if action == 'add'
      begin
        sf_relation = OpenStax::Salesforce::Remote::AccountContactRelation.new(
          contact_id: relation.contact_id,
          school_id: relation.school_id
        )
        sf_relation.save!
      rescue => e
        Sentry.capture_exception e
        relation.destroy!
        raise
      end

    elsif action == 'remove'
      begin
        sf_relation = OpenStax::Salesforce::Remote::AccountContactRelation.find_by(
          contact_id: relation.contact_id,
          school_id: relation.school_id
        )
        sf_relation&.destroy
        relation.destroy!

      rescue => e
        Sentry.capture_exception e
        raise
      end
    end
  end
end
