class PushLeadToSalesforceJob < ApplicationJob
  queue_as :leads

  # keep the status in the database for a day, in case we need to inspect
  def expiration
    @expiration ||= 60 * 60 * 24 # 1 days
  end

  def perform(lead_id)
    lead = Lead.find(lead_id)

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
      # TODO: why are we storing this as a string
      newsletter: lead.newsletter == 't' ? true : false,
      # TODO: why are we storing this as a string
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
end
