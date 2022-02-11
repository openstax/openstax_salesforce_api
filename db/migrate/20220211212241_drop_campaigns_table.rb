class DropCampaignsTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :campaigns
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
