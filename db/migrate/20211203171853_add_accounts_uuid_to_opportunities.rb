class AddAccountsUuidToOpportunities < ActiveRecord::Migration[6.1]
  def change
    add_column :opportunities, :accounts_uuid, :string
  end
end
