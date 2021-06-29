class PushOpportunityToSalesforceJob < ApplicationJob
  queue_as :default

  def perform(opportunity_data)
    begin
      if opportunity_data[:salesforce_id]
        opportunity = OpenStax::Salesforce::Remote::Opportunity.find(opportunity_data[:salesforce_id])
        opportunity.update(
          contact_id: opportunity_data[:contact_id],
          close_date: opportunity_data[:close_date],
          stage_name: 'Confirmed Adoption Won',
          type: 'Renewal - Verified',
          number_of_students: opportunity_data[:number_of_students],
          student_number_status: 'Reported',
          time_period: 'Year',
          class_start_date: opportunity_data[:class_start_date],
          school_id: opportunity_data[:school_id],
          book_id: opportunity_data[:book_id],
          lead_source: 'Web'
        )
      else
        opportunity = OpenStax::Salesforce::Remote::Opportunity.new(
          name: 'new from openstax-salesforce-api',
          contact_id: opportunity_data[:contact_id],
          close_date: opportunity_data[:close_date],
          stage_name: 'Confirmed Adoption Won',
          type: 'New Business',
          number_of_students: opportunity_data[:number_of_students],
          student_number_status: 'Reported',
          time_period: 'Year',
          class_start_date: opportunity_data[:class_start_date],
          school_id: opportunity_data[:school_id],
          book_id: opportunity_data[:book_id],
          lead_source: 'Web'
        )
        opportunity.save
      end
    rescue => e
      Rails.logger.warn(e)
    end

    opportunity
  end
end
