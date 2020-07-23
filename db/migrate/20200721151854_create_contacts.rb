class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :salesforce_id
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :email_alt
      t.datetime :faculty_confirmed_date
      t.string :faculty_verified
      t.datetime :last_modified_at
      t.string :school_id
      t.string :school_type
      t.string :send_faculty_verification_to
      t.string :all_emails
      t.string :confirmed_emails
      t.string :adoption_status

      t.timestamps
    end
  end
end
