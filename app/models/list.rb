class List < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :contacts, through: :subscriptions

  def subscribe(subscription_id)
    SubscribeToListJob.perform_later(subscription_id)
  end

  def unsubscribe(subscription_id)
    UnsubscribeFromListJob.perform_later(subscription_id)
  end
end
