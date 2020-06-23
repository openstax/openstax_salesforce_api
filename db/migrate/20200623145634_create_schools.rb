class CreateSchools < ActiveRecord::Migration[6.0]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :type
      t.string :location
      t.boolean :is_kip
      t.boolean :is_child_of_kip

      t.timestamps
    end
  end
end
