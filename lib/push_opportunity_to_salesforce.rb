class PushOpportunityToSalesforce

  def find_or_create_opportunity(opportunity_data)
    if opportunity_data['salesforce_id'] == ''
      create_new_opportunity(opportunity_data)
    else
      update_opportunity(opportunity_data)
    end

  end

  def create_new_opportunity(opportunity_data)
    opportunity = OpenStax::Salesforce::Remote::Opportunity.new(
      term_year: opportunity_data['term_year'],
      book_name: opportunity_data['book_name'],
      contact_id: opportunity_data['contact_id'],
      new: opportunity_data['new'],
      close_date: opportunity_data['close_date'],
      stage_name: 'Confirmed Adoption (1)',
      type: opportunity_data['update_type'],
      number_of_students: opportunity_data['number_of_students'],
      student_number_status: 'Reported',
      time_period: 'Year',
      class_start_date: opportunity_data['class_start_date'],
      school_id: opportunity_data['school_id'],
      book_id: Book.find(name: opportunity_data['book_name']).salesforce_id,
      lead_source: 'openstax-salesforce-api'
    )
    opportunity.save

    if opportunity.errors.any?
      Rails.logger.warn('Error creating opportunity in salesforce:' + opportunity.errors.inspect)
      false
    else
      true
    end
  end

  def update_opportunity(opportunity_data)
    opportunity = OpenStax::Salesforce::Remote::Opportunity.find(opportunity_data['salesforce_id'])
    opportunity.update(
      term_year: opportunity_data['term_year'],
      book_name: opportunity_data['book_name'],
      contact_id: opportunity_data['contact_id'],
      new: opportunity_data['new'],
      close_date: opportunity_data['close_date'],
      stage_name: 'Confirmed Adoption (1)',
      type: opportunity_data['update_type'],
      number_of_students: opportunity_data['number_of_students'],
      student_number_status: 'Reported',
      time_period: 'Year',
      class_start_date: opportunity_data['class_start_date'],
      school_id: opportunity_data['school_id'],
      book_id: Book.find(name: opportunity_data['book_name']).salesforce_id,
      lead_source: 'openstax-salesforce-api'
    )

    if opportunity.errors.any?
      Rails.logger.warn('Error updating opportunity in salesforce:' + opportunity.errors.inspect)
      false
    else
      true
    end
  end
end

