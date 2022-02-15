class RemoveAccountsTable < ActiveRecord::Migration[6.1]
  def change
    table_exists?(:openstax_accounts_accounts) ? drop_table(:openstax_accounts_accounts) : nil
  end
end
