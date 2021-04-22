class SyncSalesforceJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 1
  SF_PACKAGE = 'OpenStax::Salesforce::Remote::'.freeze
  SF_OBJECTS = %w[Book CampaignMember Campaign Contact Lead Opportunity School].freeze

  def perform(objects = [])
    if objects.empty?
      update_objects(SF_OBJECTS)
    else
      update_objects(objects)
    end
  end

  def update_objects(object_names)
    object_names.each do |name|
      sf_objs = retrieve_salesforce_data(name)
      case name
      when 'Book'
        puts "update_books: started"
        update_books(sf_objs)
      when 'CampaignMember'
        puts "update_campaign_members: started"
        update_campaign_members(sf_objs)
      when 'Campaign'
        puts "update_campaigns: started"
        update_campaigns(sf_objs)
      when 'Contact'
        puts "update_contacts: started"
        update_contacts(sf_objs)
      when 'Lead'
        puts "update_leads: started"
        update_leads(sf_objs)
      when 'Opportunity'
        puts "update_opportunities: started"
        update_opportunities(sf_objs)
      when 'School'
        puts "update_schools: started"
        update_schools(sf_objs)
      else
        puts 'object not found.'
      end
      delete_objects_not_in_salesforce(name, sf_objs)
    end
    
  end

  def retrieve_salesforce_data(name)
    class_name = SF_PACKAGE + name
    class_name.constantize.all
  end

  def update_books(sf_books)
    sf_books.each do |sf_book|
      book_to_update = Book.find_or_initialize_by(salesforce_id: sf_book.id)
      book_to_update.salesforce_id = sf_book.id
      book_to_update.name = sf_book.name

      book_to_update.save if book_to_update.changed?
    end
  end

  def update_campaign_members(sf_campaign_members)
    sf_campaign_members.each do |sf_campaign_member|
      campaign_member_to_update = CampaignMember.find_or_initialize_by(salesforce_id: sf_campaign_member.id)
      campaign_member_to_update.salesforce_id = sf_campaign_member.id
      campaign_member_to_update.campaign_id = sf_campaign_member.campaign_id
      campaign_member_to_update.contact_id = sf_campaign_member.contact_id
      campaign_member_to_update.accounts_uuid = sf_campaign_member.accounts_uuid
      campaign_member_to_update.pardot_reported_contact_id = sf_campaign_member.pardot_reported_contact_id
      campaign_member_to_update.pardot_reported_piaid = sf_campaign_member.pardot_reported_piaid
      campaign_member_to_update.pardot_reported_picid = sf_campaign_member.pardot_reported_picid
      campaign_member_to_update.first_teacher_contact_id = sf_campaign_member.first_teacher_contact_id
      campaign_member_to_update.arrived_marketing_page_from_pardot_at = sf_campaign_member.arrived_marketing_page_from_pardot_at
      campaign_member_to_update.arrived_marketing_page_not_from_pardot_at = sf_campaign_member.arrived_marketing_page_not_from_pardot_at
      campaign_member_to_update.first_arrived_my_courses_at = sf_campaign_member.first_arrived_my_courses_at
      campaign_member_to_update.preview_created_at = sf_campaign_member.preview_created_at
      campaign_member_to_update.real_course_created_at = sf_campaign_member.real_course_created_at
      campaign_member_to_update.like_preview_ask_later_count = sf_campaign_member.like_preview_ask_later_count
      campaign_member_to_update.like_preview_yes_at = sf_campaign_member.like_preview_yes_at
      campaign_member_to_update.latest_adoption_decision = sf_campaign_member.latest_adoption_decision
      campaign_member_to_update.latest_adoption_decision_at = sf_campaign_member.latest_adoption_decision_at
      campaign_member_to_update.estimated_enrollment = sf_campaign_member.estimated_enrollment
      campaign_member_to_update.ignored_osas = sf_campaign_member.ignored_osas
      campaign_member_to_update.percent_enrolled = sf_campaign_member.percent_enrolled
      campaign_member_to_update.school_type = sf_campaign_member.school_type
      campaign_member_to_update.students_registered = sf_campaign_member.students_registered
      campaign_member_to_update.students_reported_by_teacher = sf_campaign_member.students_reported_by_teacher
      campaign_member_to_update.students_with_work = sf_campaign_member.students_with_work
      campaign_member_to_update.sync_field = sf_campaign_member.sync_field

      campaign_member_to_update.save if campaign_member_to_update.changed?
    end
  end

  def update_campaigns(sf_campaigns)
    sf_campaigns.each do |sf_campaign|
      campaign_to_update = Campaign.find_or_initialize_by(salesforce_id: sf_campaign.id)
      campaign_to_update.salesforce_id = sf_campaign.id
      campaign_to_update.name = sf_campaign.name
      campaign_to_update.is_active = sf_campaign.is_active

      campaign_to_update.save if campaign_to_update.changed?
    end
  end

  def update_contacts(sf_contacts)
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
  end

  def update_leads(sf_leads)
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
  end

  def update_opportunities(sf_opportunities)
    sf_opportunities.each do |sf_opportunity|
      opportunity_to_update = Opportunity.find_or_initialize_by(salesforce_id: sf_opportunity.id)
      opportunity_to_update.salesforce_id = sf_opportunity.id
      opportunity_to_update.term_year = sf_opportunity.term_year
      opportunity_to_update.book_name = sf_opportunity.book_name
      opportunity_to_update.contact_id = sf_opportunity.contact_id
      opportunity_to_update.new = sf_opportunity.new
      opportunity_to_update.close_date = sf_opportunity.close_date
      opportunity_to_update.stage_name = sf_opportunity.stage_name
      opportunity_to_update.update_type = sf_opportunity.type
      opportunity_to_update.number_of_students = sf_opportunity.number_of_students
      opportunity_to_update.student_number_status = sf_opportunity.student_number_status
      opportunity_to_update.time_period = sf_opportunity.time_period
      opportunity_to_update.class_start_date = sf_opportunity.class_start_date
      opportunity_to_update.school_id = sf_opportunity.school_id
      opportunity_to_update.book_id = sf_opportunity.book_id
      opportunity_to_update.lead_source = sf_opportunity.lead_source
      opportunity_to_update.os_accounts_id = sf_opportunity.os_accounts_id
      opportunity_to_update.name = sf_opportunity.name

      opportunity_to_update.save if opportunity_to_update.changed?
    end
  end

  def update_schools(sf_schools)
    sf_schools.each do |sf_school|
      school_to_update = School.find_or_initialize_by(salesforce_id: sf_school.id)
      school_to_update.salesforce_id = sf_school.id
      school_to_update.name = sf_school.name
      school_to_update.school_type = sf_school.type
      school_to_update.location = sf_school.school_location
      school_to_update.is_kip = sf_school.is_kip
      school_to_update.is_child_of_kip = sf_school.is_child_of_kip

      school_to_update.save if school_to_update.changed?
    end
  end

  def delete_objects_not_in_salesforce(name, sf_objs)
    name.constantize.where.not(salesforce_id: sf_objs.map(&:id)).delete_all
  end
end
