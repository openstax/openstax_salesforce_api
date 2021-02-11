class CreateLists < ActiveRecord::Migration[6.0]
  def change
    create_table :lists do |t|
      t.integer :pardot_id
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
