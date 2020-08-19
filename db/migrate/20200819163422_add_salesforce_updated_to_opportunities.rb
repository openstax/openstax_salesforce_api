class AddSalesforceUpdatedToOpportunities < ActiveRecord::Migration[6.0]
  def change
    add_column :opportunities, :salesforce_updated, :boolean, default: true
  end
end
