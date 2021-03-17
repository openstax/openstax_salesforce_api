class Contact < ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true
  has_many :subscriptions
  has_many :lists, through: :subscriptions

  def list_subscriptions
    @list_subscriptions = []
    # add all the lists to the subscriptions array, we update subscribed to true below
    # this reduces calls to the API by providing all available lists in the users API
    List.all.each do |list|
      @list_subscriptions.push({ id: list.pardot_id,
                                 title: list.title,
                                 description: list.description,
                                 subscribed: subscriptions.any? { |subscription| subscription.list == list } })
    end
    @list_subscriptions
  end
end
