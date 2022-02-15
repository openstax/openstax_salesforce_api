class RemoveAccountsTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :openstax_accounts_accounts
  end
end
