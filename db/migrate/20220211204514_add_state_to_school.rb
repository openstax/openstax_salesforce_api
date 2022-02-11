class AddStateToSchool < ActiveRecord::Migration[6.1]
  def change
    add_column :schools, :state, :string
  end
end
