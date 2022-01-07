class AddAccountsUuidToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :accounts_uuid, :string
  end
end
