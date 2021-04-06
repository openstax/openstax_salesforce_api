class AddStatusToSubscription < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :status, :integer
  end
end
