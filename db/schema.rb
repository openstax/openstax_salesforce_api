# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_19_163422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "salesforce_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "campaign_members", force: :cascade do |t|
    t.string "salesforce_id"
    t.string "campaign_id"
    t.string "contact_id"
    t.string "accounts_uuid"
    t.string "pardot_reported_contact_id"
    t.string "pardot_reported_piaid"
    t.string "pardot_reported_picid"
    t.string "first_teacher_contact_id"
    t.datetime "arrived_marketing_page_from_pardot_at"
    t.datetime "arrived_marketing_page_not_from_pardot_at"
    t.datetime "first_arrived_my_courses_at"
    t.datetime "preview_created_at"
    t.datetime "real_course_created_at"
    t.integer "like_preview_ask_later_count"
    t.datetime "like_preview_yes_at"
    t.string "latest_adoption_decision"
    t.datetime "latest_adoption_decision_at"
    t.integer "estimated_enrollment"
    t.boolean "ignored_osas"
    t.integer "percent_enrolled"
    t.string "school_type"
    t.integer "students_registered"
    t.integer "students_reported_by_teacher"
    t.integer "students_with_work"
    t.datetime "sync_field"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "salesforce_id"
    t.string "name"
    t.boolean "is_active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "salesforce_id"
    t.string "name"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "email_alt"
    t.datetime "faculty_confirmed_date"
    t.string "faculty_verified"
    t.datetime "last_modified_at"
    t.string "school_id"
    t.string "school_type"
    t.string "send_faculty_verification_to"
    t.string "all_emails"
    t.string "confirmed_emails"
    t.string "adoption_status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "grant_tutor_access"
  end

  create_table "leads", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "salutation"
    t.string "subject"
    t.string "school"
    t.string "phone"
    t.string "website"
    t.string "status"
    t.string "email"
    t.string "source"
    t.string "newsletter"
    t.string "newsletter_opt_in"
    t.string "adoption_status"
    t.bigint "num_students"
    t.string "os_accounts_id"
    t.string "accounts_uuid"
    t.string "application_source"
    t.string "role"
    t.string "who_chooses_books"
    t.string "verification_status"
    t.boolean "finalize_educator_signup"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "salesforce_id"
    t.string "name"
  end

  create_table "opportunities", force: :cascade do |t|
    t.string "salesforce_id"
    t.string "term_year"
    t.string "book_name"
    t.string "contact_id"
    t.boolean "new"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "close_date"
    t.string "stage_name"
    t.string "update_type"
    t.string "number_of_students"
    t.string "student_number_status"
    t.string "time_period"
    t.datetime "class_start_date"
    t.string "school_id"
    t.string "book_id"
    t.string "lead_source"
    t.boolean "salesforce_updated", default: true
  end

  create_table "schools", force: :cascade do |t|
    t.string "salesforce_id"
    t.string "name"
    t.string "school_type"
    t.string "location"
    t.boolean "is_kip"
    t.boolean "is_child_of_kip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
