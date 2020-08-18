class AddFieldsToOpportunities < ActiveRecord::Migration[6.0]
  def change
    add_column :opportunities, :close_date, :datetime
    add_column :opportunities, :stage_name, :string
    add_column :opportunities, :type, :string
    add_column :opportunities, :number_of_students, :string
    add_column :opportunities, :student_number_status, :string
    add_column :opportunities, :time_period, :string
    add_column :opportunities, :class_start_date, :datetime
    add_column :opportunities, :school_id, :string
    add_column :opportunities, :book_id, :string
    add_column :opportunities, :lead_source, :string
  end
end
