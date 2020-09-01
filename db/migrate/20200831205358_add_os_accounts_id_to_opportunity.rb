class AddOsAccountsIdToOpportunity < ActiveRecord::Migration[6.0]
  def change
    add_column :opportunities, :os_accounts_id, :string
  end
end
