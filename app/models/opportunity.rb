class Opportunity <ApplicationRecord
  attribute :record_type_id, :string, default: :book_adoption_record_id

  enum stage_names: {
    won: 'Confirmed Adoption Won',
    lost: 'Closed Lost'
  }, _prefix: :opportunity

  enum update_types: {
    new_business: 'New Business',
    renewal: 'Renewal',
    verified: 'Renewal - Verified'
  }, _prefix: :opportunity

  def self.search(uuid)
    where(accounts_uuid: uuid)
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
    opportunity.stage_name = sf_opportunity.stage_name
    opportunity.update_type = sf_opportunity.type
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
  # Get's the Opportunity record type id from Salesforce for type of BookOpps
  def book_adoption_record_id
    OpenStax::Salesforce::Remote::RecordType.find_by(salesforce_object_name: 'Opportunity', name: 'Book Opp').id
  end

  # give it a salesforce_id, it'll give you the remote OpenStax::Salesforce::Remote::Opportunity object
  def sf_opportunity_by_id(salesforce_id)
    @sf_opportunity = OpenStax::Salesforce::Remote::Opportunity.find(salesforce_id)
  end

  # give it a UUID, it'll return the Opportunity, or look to Salesforce if one exists we don't have
  def self.find_or_fetch_by_uuid(uuid)
    opportunities = where(accounts_uuid: uuid)
    if opportunities.nil?
      sf_opportunities = OpenStax::Salesforce::Remote::Opportunity.where(accounts_uuid: uuid)
      sf_opportunities.each do |sf_opportunity|
        cache_local(sf_opportunity)
      end
    end
    where(accounts_uuid: uuid)
  end

  private

  # TODO: this might be a duplicate of OpenStax::Salesforce::Remote::TermYear
  # returns a Date object based on when the Opportunity is being created
  def calculate_start_date
    year = Date.today.year
    between_april_and_november = Date.today.between?(Date.strptime(year.to_s + '-04-01', '%Y-%m-%d'), Date.strptime(year.to_s + '-11-01', '%Y-%m-%d'))

    fall_semester = Date.strptime(year.to_s + '-08-15', '%Y-%m-%d')
    spring_semester = Date.strptime(year.to_s + '-01-06', '%Y-%m-%d')

    @start_date = between_april_and_november ? fall_semester : spring_semester
  end
end
