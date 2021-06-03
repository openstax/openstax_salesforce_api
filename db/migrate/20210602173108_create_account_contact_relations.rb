class CreateAccountContactRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :account_contact_relations do |t|
      t.string :contact_id
      t.string :salesforce_id
      t.boolean :primary
      t.string :school_id
      t.string :string

      t.timestamps
    end
  end
end
