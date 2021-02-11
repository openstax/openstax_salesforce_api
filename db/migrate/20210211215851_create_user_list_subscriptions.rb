class CreateUserListSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_list_subscriptions do |t|
      t.references :contact
      t.references :list

      t.timestamps
    end
  end
end
