class UpdateOpportunitiesFromSalesforce
  def self.call
    new.start_update
  end

  def start_update
    sf_opportunities = retrieve_salesforce_data
    update_opportunities(sf_opportunities)
  end

  def retrieve_salesforce_data
    OpenStax::Salesforce::Remote::Opportunity
        .select(:id, :term_year, :book_name, :contact_id, :new, :close_date, :stage_name,
                :type, :number_of_students, :student_number_status, :time_period, :class_start_date, :school_id,
                :book_id, :lead_source, :os_accounts_id, :name)
        .to_a
  end

  def update_opportunities(sf_opportunities)
    sf_opportunities.each do |sf_opportunity|
      opportunity_to_update = Opportunity.find_or_initialize_by(salesforce_id: sf_opportunity.id)
      opportunity_to_update.salesforce_id = sf_opportunity.id
      opportunity_to_update.term_year = sf_opportunity.term_year
      opportunity_to_update.book_name = sf_opportunity.book_name
      opportunity_to_update.contact_id = sf_opportunity.contact_id
      opportunity_to_update.new = sf_opportunity.new
      opportunity_to_update.close_date = sf_opportunity.close_date
      opportunity_to_update.stage_name = sf_opportunity.stage_name
      opportunity_to_update.update_type = sf_opportunity.type
      opportunity_to_update.number_of_students = sf_opportunity.number_of_students
      opportunity_to_update.student_number_status = sf_opportunity.student_number_status
      opportunity_to_update.time_period = sf_opportunity.time_period
      opportunity_to_update.class_start_date = sf_opportunity.class_start_date
      opportunity_to_update.school_id = sf_opportunity.school_id
      opportunity_to_update.book_id = sf_opportunity.book_id
      opportunity_to_update.lead_source = sf_opportunity.lead_source
      opportunity_to_update.os_accounts_id = sf_opportunity.os_accounts_id
      opportunity_to_update.name = sf_opportunity.name

      opportunity_to_update.save if opportunity_to_update.changed?
    end
    delete_opportunities_removed_from_salesforce(sf_opportunities)
  end

  def delete_opportunities_removed_from_salesforce(sf_opportunities)
    sfapi_opportunities = Opportunity.all

    sfapi_opportunities.each do |sfapi_opportunity|
      found = false
      sf_opportunities.each do |sf_opportunity|
        found = true if sf_opportunity.id == sfapi_opportunity.salesforce_id
        break if found
      end
      Opportunity.destroy(sfapi_opportunity.id) unless found
    end
  end
end
