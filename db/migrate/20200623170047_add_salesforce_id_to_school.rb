class AddSalesforceIdToSchool < ActiveRecord::Migration[6.0]
  def change
    add_column :schools, :salesforce_id, :string
  end
end
