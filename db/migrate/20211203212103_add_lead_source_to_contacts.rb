class AddLeadSourceToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :lead_source, :string
  end
end
