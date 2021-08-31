class PushOpportunityToSalesforceJob < ApplicationJob
  queue_as :default

  def perform(opp)
    book = Book.find_by!(name: opp.book_name)

    begin
      if opp.salesforce_id
        opportunity = OpenStax::Salesforce::Remote::Opportunity.find(opp.salesforce_id)
        opportunity.update(
          contact_id: opp.contact_id,
          close_date: Date.today.strftime('%Y-%m-%d'),
          stage_name: 'Confirmed Adoption Won',
          type: 'Renewal - Verified',
          number_of_students: opp.number_of_students,
          student_number_status: 'Reported',
          time_period: 'Year',
          class_start_date: opp.class_start_date.strftime('%Y-%m-%d'),
          school_id: opp.school_id,
          book_id: book.salesforce_id,
          lead_source: 'Web'
        )
        opportunity.save
      else
        opportunity = OpenStax::Salesforce::Remote::Opportunity.new(
          name: 'new from openstax-salesforce-api',
          contact_id: opp.contact_id,
          close_date: Date.today.strftime('%Y-%m-%d'),
          stage_name: 'Confirmed Adoption Won',
          type: 'New Business',
          number_of_students: opp.number_of_students,
          student_number_status: 'Reported',
          time_period: 'Year',
          class_start_date: opp.class_start_date.strftime('%Y-%m-%d'),
          school_id: opp.school_id,
          book_id: book.salesforce_id,
          lead_source: 'Web'
        )
        opportunity.save

        # update the local opportunity with data from salesforce
        opp.book_id = book.salesforce_id
        opp.update_type = opportunity.type
        opp.salesforce_id = opportunity.id
        opp.save
      end
    rescue => e
      Sentry.capture_exception(e)
    end

    opportunity
  end
end
