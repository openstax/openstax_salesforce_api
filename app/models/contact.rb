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

    unless Subscription.exists?(contact: self)
      # no subscriptions found locally, let's update from Pardot
      @client = Pardot.client

      begin
        @prospect = @client.prospects.read_by_fid(salesforce_id)

        @prospect['lists']['list_subscription'].each do |subscription|
          next unless subscription['list']['is_public'] == 'true'

          list = List.where(pardot_id: subscription['list']['id']).first_or_create do |plist|
            plist.title = subscription['list']['title']
            plist.description = subscription['list']['description']
          end

          Subscription.create list: list, contact: self
        end
      rescue Pardot::ResponseError
        Rails.logger.info 'No Pardot record for contact: ' + salesforce_id
      end
    end

    Subscription.where(contact: self).each do |subscription|
      subscriptions.each do |sub|
        sub[:subscribed] = true if sub[:id] == subscription.list.pardot_id
      end
    end

    subscriptions
  end
end
