class RemoveFinalizeEducatorSignupFromLeads < ActiveRecord::Migration[6.1]
  def change
    remove_column :leads, :finalize_educator_signup, :boolean
  end
end
