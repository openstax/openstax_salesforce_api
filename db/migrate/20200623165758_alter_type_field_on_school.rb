class AlterTypeFieldOnSchool < ActiveRecord::Migration[6.0]
  def change
    rename_column :schools, :type, :school_type
  end
end
