class ChangeOpportunityFieldsToEnumsWithStrings < ActiveRecord::Migration[6.1]
  def change
    # we are okay with doing this since we are still on dev :whew: and sync data from SF anyways
    # kind of have to undo the last migration, since we are actually storing strings.. just making code ref easier with enums
    change_column :opportunities, :record_type, :string
    change_column :opportunities, :stage_name, :string
    change_column :opportunities, :type, :string
    change_column :opportunities, :renewal_status, :string
  end
end
