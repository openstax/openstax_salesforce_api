class ChangeOpportunityFieldsToEnums < ActiveRecord::Migration[6.1]
  def change
    # we are okay with doing this since we are still on dev :whew: and sync data from SF anyways
    # done to support using enums for opportunity fields
    remove_column :opportunities, :record_type_name
    add_column :opportunities, :record_type, :integer

    remove_column :opportunities, :stage_name
    add_column :opportunities, :stage_name, :integer

    remove_column :opportunities, :update_type
    add_column :opportunities, :type, :integer

    add_column :opportunities, :renewal_status, :integer


    # we'll also remove unneeded columns from our local database - these won't be used in the app
    # lead_source in particular is being deprecated from our Opp data model in SF
    remove_column :opportunities, :new
    remove_column :opportunities, :lead_source
    remove_column :opportunities, :os_accounts_id
  end
end
