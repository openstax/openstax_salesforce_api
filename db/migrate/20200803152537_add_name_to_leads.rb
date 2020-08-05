class AddNameToLeads < ActiveRecord::Migration[6.0]
  def change
    add_column :leads, :name, :string
  end
end
