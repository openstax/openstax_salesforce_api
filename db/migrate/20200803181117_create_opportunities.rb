class CreateOpportunities < ActiveRecord::Migration[6.0]
  def change
    create_table :opportunities do |t|
      t.string :salesforce_id
      t.string :term_year
      t.string :book_name
      t.string :contact_id
      t.boolean :new

      t.timestamps
    end
  end
end
