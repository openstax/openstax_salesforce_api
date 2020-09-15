class PushOpportunityToSalesforce

  def find_or_create_opportunity(opportunity_data)
    success = false;
    if opportunity_data['salesforce_id'] == ''
      success = create_new_opportunity(opportunity_data)
    else
      success = update_opportunity(opportunity_data)
    end
  end

  def create_new_opportunity(opportunity_data)
    opportunity = OpenStax::Salesforce::Remote::Opportunity.new(
      name: 'new from openstax-salesforce-api',
      contact_id: opportunity_data[:contact_id],
      close_date: opportunity_data[:close_date],
      stage_name: 'Confirmed Adoption (1)',
      type: 'New Business',
      number_of_students: opportunity_data[:number_of_students],
      student_number_status: 'Reported',
      time_period: 'Year',
      class_start_date: opportunity_data[:class_start_date],
      school_id: opportunity_data[:school_id],
      book_id: get_book_id(opportunity_data[:book_name]),
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
    opportunity = OpenStax::Salesforce::Remote::Opportunity.find(opportunity_data[:salesforce_id])
    opportunity.update(
      name: opportunity_data[:name],
      contact_id: opportunity_data[:contact_id],
      close_date: opportunity_data[:close_date],
      stage_name: 'Confirmed Adoption (1)',
      type: 'Renewal - Verified',
      number_of_students: opportunity_data[:number_of_students],
      student_number_status: 'Reported',
      time_period: 'Year',
      class_start_date: opportunity_data[:class_start_date],
      school_id: opportunity_data[:school_id],
      book_id: get_book_id(opportunity_data[:book_name]),
      lead_source: 'openstax-salesforce-api'
    )

    if opportunity.errors.any?
      Rails.logger.warn('Error updating opportunity in salesforce:' + opportunity.errors.inspect)
      false
    else
      true
    end
  end

  def get_book_id(book_name)
    id_of_book = nil
    book = Book.where(name: book_name)
    unless book[0].nil?
      id_of_book = book[0]['salesforce_id']
    end
    return id_of_book
  end
end

