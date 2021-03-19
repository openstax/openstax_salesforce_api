class UpdateCampaignMembersFromSalesforce
  def self.call
    new.start_update
  end

  def start_update
    sf_campaign_members = retrieve_salesforce_data
    update_campaign_members(sf_campaign_members)
  end

  def retrieve_salesforce_data
    OpenStax::Salesforce::Remote::CampaignMember
        .select(:id, :campaign_id, :contact_id, :accounts_uuid, :pardot_reported_contact_id, :pardot_reported_piaid, :fpardot_reported_picid,
                :first_teacher_contact_id,
                :arrived_marketing_page_from_pardot_at, :arrived_marketing_page_not_from_pardot_at, :first_arrived_my_courses_at,
                :preview_created_at, :real_course_created_at, :like_preview_ask_later_count, :like_preview_yes_at, :latest_adoption_decision,
                :latest_adoption_decision_at, :estimated_enrollment, :ignored_osas, :percent_enrolled, :school_type, :students_registered,
                :students_reported_by_teacher, :students_with_work, :sync_field)
        .to_a
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
    delete_campaign_members_removed_from_salesforce(sf_campaign_members)
  end

  def delete_campaign_members_removed_from_salesforce(sf_campaign_members)
    sfapi_campaign_members = CampaignMember.all

    sfapi_campaign_members.each do |sfapi_campaign_member|
      found = false
      sf_campaign_members.each do |sf_campaign_member|
        found = true if sf_campaign_member.id == sfapi_campaign_member.salesforce_id
        break if found
      end
      CampaignMember.destroy(sfapi_campaign_member.id) unless found
    end
  end
end
