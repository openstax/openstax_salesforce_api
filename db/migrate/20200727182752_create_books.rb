class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :salesforce_id, unique: true, require: true
      t.string :name

      t.timestamps
    end
  end
end
