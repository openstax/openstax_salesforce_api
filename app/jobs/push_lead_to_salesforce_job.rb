class PushLeadToSalesforceJob < ApplicationJob
  queue_as :default

  def perform(lead)
    begin
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
      source: 'OSC Faculty',
      newsletter: lead.newsletter=='t' ? true : false,
      newsletter_opt_in: lead.newsletter_opt_in=='t' ? true : false,
      adoption_status: lead.adoption_status,
      num_students: lead.num_students,
      os_accounts_id: lead.os_accounts_id,
      accounts_uuid: lead.accounts_uuid,
      application_source: 'OS Web',
      role: lead.role,
      who_chooses_books: lead.who_chooses_books,
      verification_status: lead.verification_status,
      finalize_educator_signup: lead.finalize_educator_signup
      )
      sf_lead.save
    rescue => e
      Sentry.capture_exception(e)
    end
  end
end
