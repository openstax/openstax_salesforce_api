class AddRelationsToAccountContact < ActiveRecord::Migration[6.1]
  def change
    add_reference :schools, :school_id
    add_reference :contacts, :contact_id
  end
end
