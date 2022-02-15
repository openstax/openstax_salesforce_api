class PushOpportunityToSalesforceJob < ApplicationJob
  queue_as :default

  def perform(opp)
    book = Book.find_by!(name: opp.book_name)

    begin
      if !opp.salesforce_id.blank?
        opportunity = Opportunity.sf_opportunity_by_id(opp.salesforce_id)
        opportunity.update(
          contact_id: opp.contact_id,
          close_date: Date.today.strftime('%Y-%m-%d'),
          stage_name: opp.stage_name,
          type: 'Renewal - Verified',
          number_of_students: opp.number_of_students,
          student_number_status: 'Reported',
          time_period: 'Year',
          school_id: opp.school_id,
          book_id: book.salesforce_id,
          lead_source: 'Web'
        )
        opportunity.save
      else
        db_record_type_id = Opportunity.first.record_type_id
        # TODO: what is start date used for?
        start_date = opp.class_start_date.blank? ? Date.today.strftime('%Y-%m-%d') : opp.class_start_date.strftime('%Y-%m-%d')
        opportunity = OpenStax::Salesforce::Remote::Opportunity.new(
          name: 'new from openstax-salesforce-api',
          contact_id: opp.contact_id,
          close_date: Date.today.strftime('%Y-%m-%d'),
          stage_name: 'Confirmed Adoption Won',
          type: 'New Business',
          number_of_students: opp.number_of_students,
          student_number_status: 'Reported',
          time_period: 'Year',
          class_start_date: calculate_start_date,
          school_id: opp.school_id,
          book_id: book.salesforce_id,
          lead_source: 'Web',
          record_type_id: db_record_type_id
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

  def calculate_start_date
    year = Date.today.year
    between_april_and_november = Date.today.between?(Date.strptime(year.to_s + '-04-01', '%Y-%m-%d'), Date.strptime(year.to_s + '-11-01', '%Y-%m-%d'))

    fall_semester = Date.strptime(year.to_s + '-08-15', '%Y-%m-%d')
    spring_semester = Date.strptime(year.to_s + '-01-06', '%Y-%m-%d')

    between_april_and_november ? fall_semester : spring_semester
  end
end
