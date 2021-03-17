class Contact < ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true
  has_many :subscriptions
  has_many :lists, through: :subscriptions

  def list_subscriptions
    subscriptions = []
    # add all the lists to the subscriptions array, we update subscribed to true below
    List.all.each do |list|
      subscriptions.push({ id: list.pardot_id, title: list.title, description: list.description, subscribed: false })
    end

    Subscription.where(contact: self).each do |subscription|
      subscriptions.each do |sub|
        sub[:subscribed] = true if sub[:id] == subscription.list.pardot_id
      end
    end

    subscriptions
  end
end
