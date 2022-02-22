class DropCampaignMembersTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :campaign_members
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
