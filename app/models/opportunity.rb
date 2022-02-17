class Opportunity <ApplicationRecord

  enum stage_name: {
    won: 'Confirmed Adoption Won',
    lost: 'Closed Lost'
  }, _prefix: :opportunity

  enum type: {
    new_business: 'New Business',
    renewal: 'Renewal',
    verified: 'Renewal - Verified'
  }, _prefix: :opportunity

  enum status: {
    needs_renewal: 'Needs Renewal',
    renewed: 'Done Renewed',
    dropped: 'Dropped',
    needs_check: 'Needs Check'
  }, _prefix: :opportunity

  def self.search(uuid)
    where(accounts_uuid: uuid)
  end


  # expects object type of SFAPI Opportunity
  def self.push_or_update(opportunity)
    sf_opportunity = sf_opportunity_by_uuid(opportunity.accounts_uuid)

    # The common stuff we need for an opp to be created or updated
    sf_opportunity.close_date = Date.today.strftime('%Y-%m-%d')
    sf_opportunity.stage_name = stage_names[:won]
    sf_opportunity.number_of_students = self.number_of_students
    sf_opportunity.time_period = 'Year' # TODO: what are the options for this?
    sf_opportunity.student_number_status = 'Reported' # TODO: what are the options for this?
    sf_opportunity.class_start_date = calculate_start_date
    sf_opportunity.school_id = School.find_by!(salesforce_id: opportunity.school_id)
    sf_opportunity.book_id = Book.find_by!(salesforce_id: opportunity.book_id)
    sf_opportunity.record_type_id = @book_adoption_record_type

    if sf_opportunity.new_record? # this means it's new.. we need to do a few different things
      sf_opportunity.type = types[:new]
      sf_opportunity.name = '[FOR REVIEW FROM SFAPI]'
    else # this means it already exists.. so we are renewing it
      sf_opportunity.type = types[:renewed]
    end

    unless sf_opportunity.save
      Sentry.capture_message("Failed to save opportunity (id: #{self.id}) to Salesforce: #{sf_opportunity.errors}")
      raise("Error processing opportunity (id:#{self.id}) to Salesforce: #{sf_opportunity.errors}")
    end

    opportunity.book_id = sf_opportunity.salesforce_id
    opportunity.update_type = sf_opportunity.type
    opportunity.salesforce_id = sf_opportunity.id
    opportunity.save

    return opportunity
  end

  # expects an object of type
  # OpenStax::Salesforce::Remote::Opportunity
  def self.cache_local(sf_opportunity)
    opportunity = self.find_or_initialize_by(salesforce_id: sf_opportunity.id)
    opportunity.salesforce_id = sf_opportunity.id
    opportunity.term_year = sf_opportunity.term_year
    opportunity.book_name = sf_opportunity.book_name
    opportunity.contact_id = sf_opportunity.contact_id
    opportunity.close_date = sf_opportunity.close_date
    opportunity.renewal_status = sf_opportunity.renewal_status
    opportunity.stage_name = sf_opportunity.stage_name
    opportunity.type = sf_opportunity.type
    opportunity.number_of_students = sf_opportunity.number_of_students
    opportunity.student_number_status = sf_opportunity.student_number_status
    opportunity.time_period = sf_opportunity.time_period
    opportunity.class_start_date = sf_opportunity.class_start_date
    opportunity.school_id = sf_opportunity.school_id
    opportunity.book_id = sf_opportunity.book_id
    opportunity.name = sf_opportunity.name
    opportunity.record_type_id = sf_opportunity.record_type_id
    opportunity.accounts_uuid = sf_opportunity.accounts_uuid

    opportunity.save if opportunity.changed?
    opportunity
  end

  # This could be better.. but for now, it's all we need
  def sobject_book_adoption_record_type_id
    @book_adoption_record_type = OpenStax::Salesforce::Remote::RecordType.find_by(salesforce_object_name: 'Opportunity', name: 'Book Opp').id
  end

  def sf_opportunity_by_id(salesforce_id)
    OpenStax::Salesforce::Remote::Opportunity.find(salesforce_id)
  end

  def sf_opportunity_by_uuid(uuid)
    OpenStax::Salesforce::Remote::Opportunity.find_by!(accounts_uuid: uuid)
  end

  private

  def calculate_start_date
    year = Date.today.year
    between_april_and_november = Date.today.between?(Date.strptime(year.to_s + '-04-01', '%Y-%m-%d'), Date.strptime(year.to_s + '-11-01', '%Y-%m-%d'))

    fall_semester = Date.strptime(year.to_s + '-08-15', '%Y-%m-%d')
    spring_semester = Date.strptime(year.to_s + '-01-06', '%Y-%m-%d')

    @start_date = between_april_and_november ? fall_semester : spring_semester
  end
end
