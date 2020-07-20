class AddSalesforceIdToLeads < ActiveRecord::Migration[6.0]
  def change
    add_column :leads, :salesforce_id, :string
  end
end
