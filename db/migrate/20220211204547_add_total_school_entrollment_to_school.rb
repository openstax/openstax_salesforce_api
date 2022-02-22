class AddTotalSchoolEntrollmentToSchool < ActiveRecord::Migration[6.1]
  def change
    add_column :schools, :total_school_enrollment, :string
  end
end
