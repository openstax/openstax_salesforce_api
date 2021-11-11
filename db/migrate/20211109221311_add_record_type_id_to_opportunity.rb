class AddRecordTypeIdToOpportunity < ActiveRecord::Migration[6.1]
  def change
    add_column :opportunities, :record_type_id, :string
  end
end
