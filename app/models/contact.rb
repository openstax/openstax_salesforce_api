class Contact < ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true

  has_many :subscriptions, dependent: :destroy
  has_many :lists, through: :subscriptions
  has_many :account_contact_relations

  def self.search(email)
    where(email: email)
  end

  # expects an object of type OpenStax::Salesforce::Remote::Contact
  # OpenStax::Salesforce::Remote::Contact
  def self.cache_local(sf_contact)
    contact = self.find_or_initialize_by(salesforce_id: sf_contact.id)
    contact.name = sf_contact.name
    contact.first_name = sf_contact.first_name
    contact.last_name = sf_contact.last_name
    contact.email = sf_contact.email
    contact.email_alt = sf_contact.email_alt
    contact.faculty_confirmed_date = sf_contact.faculty_confirmed_date
    contact.faculty_verified = sf_contact.faculty_verified
    contact.last_modified_at = sf_contact.last_modified_at
    contact.school_id = sf_contact.school_id
    contact.school_type = sf_contact.school_type
    contact.send_faculty_verification_to = sf_contact.send_faculty_verification_to
    contact.all_emails = sf_contact.all_emails
    contact.confirmed_emails = sf_contact.confirmed_emails
    contact.adoption_status = sf_contact.adoption_status
    contact.grant_tutor_access = sf_contact.grant_tutor_access
    contact.accounts_uuid = sf_contact.accounts_uuid
    contact.lead_source = sf_contact.lead_source

    if contact.changed?
      AccountContactRelation.find_or_create_by(contact_id: contact.salesforce_id, school_id: sf_contact.school_id)
      contact.save
    end
    contact
  end

  def self.find_or_fetch_by_uuid(uuid)
    contact = find_by(accounts_uuid: uuid)
    if contact.nil?
      sf_contact = OpenStax::Salesforce::Remote::Contact.find_by(accounts_uuid: uuid)
      raise(CannotFindUserContact) unless sf_contact
      cache_local(sf_contact)
    end
    find_by(accounts_uuid: uuid)
  end
end
