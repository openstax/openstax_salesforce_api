class SyncSalesforceContactsJob < ApplicationJob
  queue_as :default

  def perform(id=nil)
    last_id = nil
    loop do
      if id
        sf_contacts = OpenStax::Salesforce::Remote::Contact.where(id:id)
      else
        sf_contacts = OpenStax::Salesforce::Remote::Contact.order(:id).limit(BATCH_SIZE)
      end
      sf_contacts = sf_contacts.where("id > '#{last_id}'") unless last_id.nil?
      sf_contacts = sf_contacts.to_a
      last_id = sf_contacts.last.id unless sf_contacts.last.nil?

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

        return contact_to_update if sf_contacts.count == 1
      end
      break if sf_contacts.length < BATCH_SIZE
    end
    delete_objects_not_in_salesforce('Contact')
  end
end

if Sidekiq.server?
  Sidekiq::Cron::Job.create(name: 'Salesforce contact sync - every 30 min', cron: '*/30 * * * *', class: 'SyncSalesforceContactsJob')
end
