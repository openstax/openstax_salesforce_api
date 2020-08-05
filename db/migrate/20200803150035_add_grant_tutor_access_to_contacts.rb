class AddGrantTutorAccessToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :grant_tutor_access, :boolean
  end
end
