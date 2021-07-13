class RemoveSalesforceUpdatedFromOpportunities < ActiveRecord::Migration[6.1]
  def change
    remove_column :opportunities, :salesforce_updated, :boolean
  end
end
