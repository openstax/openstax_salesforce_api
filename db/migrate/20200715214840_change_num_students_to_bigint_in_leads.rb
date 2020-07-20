class ChangeNumStudentsToBigintInLeads < ActiveRecord::Migration[6.0]
  def change
    change_column :leads, :num_students, :bigint
  end
end
