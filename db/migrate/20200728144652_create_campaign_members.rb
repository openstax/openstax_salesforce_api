class CreateCampaignMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :campaign_members do |t|
      t.string :salesforce_id, unique: true, require: true
      t.string :campaign_id
      t.string :contact_id
      t.string :accounts_uuid
      t.string :pardot_reported_contact_id
      t.string :pardot_reported_piaid
      t.string :pardot_reported_picid
      t.string :first_teacher_contact_id
      t.datetime :arrived_marketing_page_from_pardot_at
      t.datetime :arrived_marketing_page_not_from_pardot_at
      t.datetime :first_arrived_my_courses_at
      t.datetime :preview_created_at
      t.datetime :real_course_created_at
      t.integer :like_preview_ask_later_count
      t.datetime :like_preview_yes_at
      t.string :latest_adoption_decision
      t.datetime :latest_adoption_decision_at
      t.integer :estimated_enrollment
      t.boolean :ignored_osas
      t.integer :percent_enrolled
      t.string :school_type
      t.integer :students_registered
      t.integer :students_reported_by_teacher
      t.integer :students_with_work
      t.datetime :sync_field

      t.timestamps
    end
  end
end
