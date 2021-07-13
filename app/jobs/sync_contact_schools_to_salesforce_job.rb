class SyncContactSchoolsToSalesforceJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 5

  def perform(relation, action)
    if action == 'add'
      begin
        sf_relation = OpenStax::Salesforce::Remote::AccountContactRelation.new(
          contact_id: relation.contact_id,
          school_id: relation.school_id
        )
        sf_relation.save!
      rescue Restforce::ErrorCode::DuplicateValue => e
        Rails.logger.warn 'This contact already belongs to this school'
        relation.destroy!
      rescue Restforce::ErrorCode::RequiredFieldMissing => e
        Rails.logger.warn 'Missing required information to create relation.'
        relation.destroy!
      rescue NoMethodError => e
        Rails.logger.warn 'Missing or invalid information information'
        relation.destroy!
      end

    elsif action == 'remove'
      sf_relation = OpenStax::Salesforce::Remote::AccountContactRelation.find_by(
        contact_id: relation.contact_id,
        school_id: relation.school_id
      )
      sf_relation&.destroy

      relation.destroy!
    end
  end
end
