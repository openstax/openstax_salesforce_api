class Opportunity <ApplicationRecord

  # expects an object of type OpenStax::Salesforce::Remote::Opportunity
  def self.cache_opportunity(sf_opportunity)
    opportunity = Opportunity.find_or_initialize_by(salesforce_id: sf_opportunity.id)
    opportunity.salesforce_id = sf_opportunity.id
    opportunity.term_year = sf_opportunity.term_year
    opportunity.book_name = sf_opportunity.book_name
    opportunity.contact_id = sf_opportunity.contact_id
    opportunity.new = sf_opportunity.new
    opportunity.close_date = sf_opportunity.close_date
    opportunity.stage_name = sf_opportunity.stage_name
    opportunity.update_type = sf_opportunity.type
    opportunity.number_of_students = sf_opportunity.number_of_students
    opportunity.student_number_status = sf_opportunity.student_number_status
    opportunity.time_period = sf_opportunity.time_period
    opportunity.class_start_date = sf_opportunity.class_start_date
    opportunity.school_id = sf_opportunity.school_id
    opportunity.book_id = sf_opportunity.book_id
    opportunity.lead_source = sf_opportunity.lead_source
    opportunity.os_accounts_id = sf_opportunity.os_accounts_id
    opportunity.name = sf_opportunity.name
    opportunity.record_type_name = sf_opportunity.record_type_name
    opportunity.record_type_id = sf_opportunity.record_type_id
    opportunity.accounts_uuid = sf_opportunity.accounts_uuid

    opportunity.save if opportunity.changed?
  end

  def self.search(uuid)
    where(accounts_uuid: uuid)
  end
end
