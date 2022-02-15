class RemoveDoorkeeperTables < ActiveRecord::Migration[6.1]
  def change
    table_exists?(:oauth_access_grants) ? drop_table(:oauth_access_grants) : nil
    table_exists?(:oauth_access_tokens) ? drop_table(:oauth_access_tokens) : nil
    table_exists?(:oauth_applications) ? drop_table(:oauth_applications) : nil
  end
end
