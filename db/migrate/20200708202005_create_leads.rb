class CreateLeads < ActiveRecord::Migration[6.0]
  def change
    create_table :leads do |t|
      t.string :first_name
      t.string :last_name
      t.string :salutation
      t.string :subject
      t.string :school
      t.string :phone
      t.string :website
      t.string :status
      t.string :email
      t.string :source
      t.string :newsletter
      t.string :newsletter_opt_in
      t.boolean :adoption_status
      t.integer :num_students
      t.string :os_accounts_id
      t.string :accounts_uuid
      t.string :application_source
      t.string :role
      t.string :who_chooses_books
      t.string :verification_status
      t.boolean :finalize_educator_signup

      t.timestamps
    end
  end
end
