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

ActiveRecord::Schema.define(version: 2020_07_15_214840) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
