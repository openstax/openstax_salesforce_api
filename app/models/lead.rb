class Lead <ApplicationRecord
  validates :salesforce_id, uniqueness: true, :allow_blank => true

  def self.search(uuid)
    where(accounts_uuid: uuid)
  end

  def self.push_lead(lead)
    sf_lead = OpenStax::Salesforce::Remote::Lead.new(
      first_name: lead.first_name,
      last_name: lead.last_name,
      salutation: lead.salutation,
      subject: lead.subject,
      school: lead.school,
      phone: lead.phone,
      website: lead.website,
      status: lead.status,
      email: lead.email,
      source: 'SFAPI',
      newsletter: lead.newsletter=='t' ? true : false,
      newsletter_opt_in: lead.newsletter_opt_in=='t' ? true : false,
      adoption_status: lead.adoption_status,
      num_students: lead.num_students,
      os_accounts_id: lead.os_accounts_id,
      accounts_uuid: lead.accounts_uuid,
      application_source: 'SFAPI',
      role: lead.role,
      who_chooses_books: lead.who_chooses_books,
      verification_status: lead.verification_status,
      )
    sf_lead.save

    lead.salesforce_id = sf_lead.id
    lead.save
  end

  # expects an object of type OpenStax::Salesforce::Remote::Lead
  def self.cache_lead(sf_lead)
    # This should be reasonable with lead merge - each user should only have one lead
    lead = Lead.find_or_initialize_by(accounts_uuid: sf_lead.accounts_uuid)
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
end
