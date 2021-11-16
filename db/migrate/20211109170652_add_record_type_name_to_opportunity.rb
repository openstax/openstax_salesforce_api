class AddRecordTypeNameToOpportunity < ActiveRecord::Migration[6.1]
  def change
    add_column :opportunities, :record_type_name, :string
  end
end
