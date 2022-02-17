class ChangeOppTypeColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :opportunities, :type, :update_type
  end
end
