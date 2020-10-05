class FixTypeColumnOnOpportunities < ActiveRecord::Migration[6.0]
  def change
    rename_column :opportunities, :type, :update_type
  end
end
