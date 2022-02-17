class RemoveOpportunityStatusField < ActiveRecord::Migration[6.1]
  def change
    remove_column :opportunities, :renewal_status
  end
end
