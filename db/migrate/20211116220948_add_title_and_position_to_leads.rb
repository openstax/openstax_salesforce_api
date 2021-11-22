class AddTitleAndPositionToLeads < ActiveRecord::Migration[6.1]
  def change
    add_column :leads, :title, :string
    add_column :leads, :position, :string
  end
end
