class PushOpportunityToSalesforceJob < ApplicationJob
  queue_as :opportunities

  def perform(salesforce_id)
    opportunity = Opportunity.find_by_salesforce_id(salesforce_id)

    if opportunity.salesforce_id
      # if the opportunity has a salesforce id, we are processing a renewal
      sf_opportunity = sf_opportunity_by_id(salesforce_id)
    else
      sf_opportunity = OpenStax::Salesforce::Remote::Opportunity.find_or_initialize_by(accounts_uuid: opportunity.accounts_uuid)
    end

    store opportunity_uuid: opportunity.accounts_uuid

    # The common stuff we need for an opp to be created or updated
    sf_opportunity.close_date = Date.today.strftime('%Y-%m-%d')
    sf_opportunity.number_of_students = number_of_students

    # TODO: what are the options for this?
    sf_opportunity.time_period = 'Year'
    # TODO: what are the options for this?
    sf_opportunity.student_number_status = 'Reported'
    # TODO: !!!this will cause problems if not in SF!!!
    sf_opportunity.school_id = School.find_by!(salesforce_id: opportunity.school_id)
    # TODO: !!!this will cause problems if not in SF!!!
    sf_opportunity.book_id = Book.find_by!(salesforce_id: opportunity.book_id)

    sf_opportunity.record_type_id = opportunity.record_type_id

    # this means it's new.. we need to do a few different things
    if sf_opportunity.new_record?
      sf_opportunity.name = '[FOR REVIEW FROM SFAPI]'
      sf_opportunity.class_start_date = opportunity.calculate_start_date
      sf_opportunity.update_type = opportunity.update_types[:new]
    # this means it already exists.. so we are renewing it
    else
      sf_opportunity.update_type = opportunity.update_types[:renewed]
      sf_opportunity.renewal_class_start_date = Date.today.strftime('%Y-%m-%d')
    end

    unless sf_opportunity.save
      Sentry.capture_message("Failed to save opportunity (id: #{self.id}) to Salesforce: #{sf_opportunity.errors}")
      raise("Error processing opportunity (id:#{self.id}) to Salesforce: #{sf_opportunity.errors}")
    end

    opportunity.book_id = sf_opportunity.book_id
    opportunity.update_type = sf_opportunity.type
    opportunity.salesforce_id = sf_opportunity.id
    opportunity.save
  end
end
