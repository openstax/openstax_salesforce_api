class SyncContactSchoolsToSalesforceJob < ApplicationJob
  queue_as :schools

  def perform(relation_id, action)
    relation = AccountContactRelation.find_by!(id: relation_id)
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
        if sf_relation.count >= 1
          sf_relation&.destroy
          relation.destroy!
        end

      rescue => e
        Sentry.capture_exception e
        raise
      end

    elsif action == 'update'
      begin
        sf_contact = OpenStax::Salesforce::Remote::Contact.find_by(id: relation.contact_id)
        sf_contact.school_id = relation.school_id
        sf_contact.save!
      rescue => e
        Sentry.capture_exception e
        raise
      end
    end
  end
end
