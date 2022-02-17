# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_17_193406) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "account_contact_relations", force: :cascade do |t|
    t.string "contact_id"
    t.string "salesforce_id"
    t.boolean "primary"
    t.string "school_id"
    t.string "string"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "salesforce_id"
    t.string "name"
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
    t.string "accounts_uuid"
    t.string "lead_source"
    t.bigint "contact_id_id"
    t.index ["contact_id_id"], name: "index_contacts_on_contact_id_id"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "salesforce_id"
    t.string "name"
    t.string "title"
    t.string "position"
  end

  create_table "lists", force: :cascade do |t|
    t.integer "pardot_id"
    t.string "title"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pardot_id"], name: "index_lists_on_pardot_id"
  end

  create_table "opportunities", force: :cascade do |t|
    t.string "salesforce_id"
    t.string "term_year"
    t.string "book_name"
    t.string "contact_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "close_date"
    t.string "number_of_students"
    t.string "student_number_status"
    t.string "time_period"
    t.datetime "class_start_date"
    t.string "school_id"
    t.string "book_id"
    t.string "name"
    t.string "record_type_id"
    t.string "accounts_uuid"
    t.string "record_type"
    t.string "stage_name"
    t.string "update_type"
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
    t.string "country"
    t.string "city"
    t.string "state"
    t.string "total_school_enrollment"
    t.bigint "school_id_id"
    t.index ["school_id_id"], name: "index_schools_on_school_id_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.bigint "list_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status"
    t.index ["contact_id"], name: "index_subscriptions_on_contact_id"
    t.index ["list_id"], name: "index_subscriptions_on_list_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "subscriptions", "contacts"
  add_foreign_key "subscriptions", "lists"
end
