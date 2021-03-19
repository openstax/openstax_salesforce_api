class UpdateLeadsFromSalesforce
  def self.call
    new.start_update
  end

  def start_update
    sf_leads = retrieve_salesforce_data
    update_leads(sf_leads)
  end

  def retrieve_salesforce_data
    OpenStax::Salesforce::Remote::Lead
        .where(source: "OSC Faculty")
        .select(:id, :first_name, :last_name, :salutation, :subject, :school, :phone,
                :website, :status, :email, :source, :newsletter, :newsletter_opt_in, :adoption_status,
                :num_students, :os_accounts_id, :accounts_uuid, :application_source, :role,
                :who_chooses_books, :verification_status, :finalize_educator_signup)
        .to_a
  end

  def update_leads(sf_leads)

    sfapi_leads = Lead.all
    sf_leads.each do |sf_lead|
      lead_to_update = Lead.find_or_initialize_by(salesforce_id: sf_lead.id)
      lead_to_update.salesforce_id = sf_lead.id
      lead_to_update.name = sf_lead.name
      lead_to_update.first_name = sf_lead.first_name
      lead_to_update.last_name = sf_lead.last_name
      lead_to_update.salutation = sf_lead.salutation
      lead_to_update.subject = sf_lead.subject
      lead_to_update.school = sf_lead.school
      lead_to_update.phone = sf_lead.phone
      lead_to_update.website = sf_lead.website
      lead_to_update.status = sf_lead.status
      lead_to_update.email = sf_lead.email
      lead_to_update.source = sf_lead.source
      lead_to_update.newsletter = sf_lead.newsletter
      lead_to_update.newsletter_opt_in = sf_lead.newsletter_opt_in
      lead_to_update.adoption_status = sf_lead.adoption_status
      lead_to_update.num_students = sf_lead.num_students
      lead_to_update.os_accounts_id = sf_lead.os_accounts_id
      lead_to_update.accounts_uuid = sf_lead.accounts_uuid
      lead_to_update.application_source = sf_lead.application_source
      lead_to_update.role = sf_lead.role
      lead_to_update.who_chooses_books = sf_lead.who_chooses_books
      lead_to_update.verification_status = sf_lead.verification_status
      lead_to_update.finalize_educator_signup = sf_lead.finalize_educator_signup

      lead_to_update.save if lead_to_update.changed?
    end
    delete_leads_removed_from_salesforce(sf_leads)
  end

  def delete_leads_removed_from_salesforce(sf_leads)
    sfapi_leads = Lead.all

    sfapi_leads.each do |sfapi_lead|
      found = false
      sf_leads.each do |sf_lead|
        found = true if sf_lead.id == sfapi_lead.salesforce_id
        break if found
      end
      Lead.destroy(sfapi_lead.id) unless found
    end
  end
end

