class AllowSalesforceIdToBeNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :opportunities, :salesforce_id, true
  end
end
