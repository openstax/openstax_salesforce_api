class CreateCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :campaigns do |t|
      t.string :salesforce_id, unique: true, require: true
      t.string :name
      t.boolean :is_active

      t.timestamps
    end
  end
end
