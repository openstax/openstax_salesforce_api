class Contact < ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true

  has_many :subscriptions, dependent: :destroy
  has_many :lists, through: :subscriptions
  has_many :account_contact_relations

  # expects an object of type OpenStax::Salesforce::Remote::Contact
  def self.cache_contact(sf_contact)
    contact = Contact.find_or_initialize_by(salesforce_id: sf_contact.id)
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
      contact.save
      # make sure they have a relation setup for the school listed on their contact
      add_school_to_user(contact.school_id)
    end
  end

  def add_school_to_user(school_id)
    AccountContactRelation.create_or_find_by!(contact_id: salesforce_id, school_id: school_id)
  end

  def self.search(email)
    where(email: email)
  end
end
