class Lead <ApplicationRecord
  validates :salesforce_id, uniqueness: true, :allow_blank => true

  def self.search(uuid)
    where(accounts_uuid: uuid)
  end

  # expects an object of type
  # OpenStax::Salesforce::Remote::Lead
  def self.cache_local(sf_lead)
    # This should be reasonable with lead merge - each user should only have one lead
    lead = find_or_initialize_by(accounts_uuid: sf_lead.accounts_uuid)
    lead.salesforce_id = sf_lead.id
    lead.name = sf_lead.name
    lead.first_name = sf_lead.first_name
    lead.last_name = sf_lead.last_name
    lead.salutation = sf_lead.salutation
    lead.subject = sf_lead.subject
    lead.school = sf_lead.school
    lead.phone = sf_lead.phone
    lead.website = sf_lead.website
    lead.status = sf_lead.status
    lead.email = sf_lead.email
    lead.source = sf_lead.source
    lead.newsletter = sf_lead.newsletter
    lead.newsletter_opt_in = sf_lead.newsletter_opt_in
    lead.adoption_status = sf_lead.adoption_status
    lead.num_students = sf_lead.num_students
    lead.os_accounts_id = sf_lead.os_accounts_id
    lead.accounts_uuid = sf_lead.accounts_uuid
    lead.application_source = sf_lead.application_source
    lead.role = sf_lead.role
    lead.who_chooses_books = sf_lead.who_chooses_books
    lead.verification_status = sf_lead.verification_status
    lead.position = sf_lead.position
    lead.title = sf_lead.title

    lead.save if lead.changed?
  end

  def self.find_or_fetch_by_uuid(uuid)
    leads = where(accounts_uuid: uuid)
    unless leads.exists?
      sf_leads = OpenStax::Salesforce::Remote::Lead.where(accounts_uuid: uuid)
      sf_leads.each do |sf_lead|
        cache_local(sf_lead)
      end
    end
    where(accounts_uuid: @uuid)
  end
end
