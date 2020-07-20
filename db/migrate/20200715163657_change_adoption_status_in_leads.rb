class ChangeAdoptionStatusInLeads < ActiveRecord::Migration[6.0]
  def change
    change_column :leads, :adoption_status, :string
  end
end
