class AddIndexToLists < ActiveRecord::Migration[6.0]
  def change
    add_index :lists, :pardot_id
  end
end
