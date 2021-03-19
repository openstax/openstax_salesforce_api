class UpdateContactsFromSalesforce
  def self.call
    new.start_update
  end

  def start_update
    sf_contacts = retrieve_salesforce_data
    update_contacts(sf_contacts)
  end

  def retrieve_salesforce_data
    OpenStax::Salesforce::Remote::Contact
        .select(:id, :name, :first_name, :last_name, :email, :email_alt, :faculty_confirmed_date, :faculty_verified,
                :last_modified_at, :school_id, :school_type, :send_faculty_verification_to, :confirmed_emails,
                :all_emails, :adoption_status, :grant_tutor_access)
        .to_a
  end

  def update_contacts(sf_contacts)
    sfapi_contacts = Contact.all
    sf_contacts.each do |sf_contact|
      contact_to_update = Contact.find_or_initialize_by(salesforce_id: sf_contact.id)
      contact_to_update.salesforce_id = sf_contact.id
      contact_to_update.name = sf_contact.name
      contact_to_update.first_name = sf_contact.first_name
      contact_to_update.last_name = sf_contact.last_name
      contact_to_update.email = sf_contact.email
      contact_to_update.email_alt = sf_contact.email_alt
      contact_to_update.faculty_confirmed_date = sf_contact.faculty_confirmed_date
      contact_to_update.faculty_verified = sf_contact.faculty_verified
      contact_to_update.last_modified_at = sf_contact.last_modified_at
      contact_to_update.school_id = sf_contact.school_id
      contact_to_update.school_type = sf_contact.school_type
      contact_to_update.send_faculty_verification_to = sf_contact.send_faculty_verification_to
      contact_to_update.all_emails = sf_contact.all_emails
      contact_to_update.confirmed_emails = sf_contact.confirmed_emails
      contact_to_update.adoption_status = sf_contact.adoption_status
      contact_to_update.grant_tutor_access = sf_contact.grant_tutor_access

      contact_to_update.save if contact_to_update.changed?
    end
    delete_contacts_removed_from_salesforce(sf_contacts)
  end

  def delete_contacts_removed_from_salesforce(sf_contacts)
    sfapi_contacts = Contact.all

    sfapi_contacts.each do |sfapi_contact|
      found = false
      sf_contacts.each do |sf_contact|
        found = true if sf_contact.id == sfapi_contact.salesforce_id
        break if found
      end
      Contact.destroy(sfapi_contact.id) unless found
    end
  end
end
