class AddNameToOpportunity < ActiveRecord::Migration[6.0]
  def change
    add_column :opportunities, :name, :string
  end
end
