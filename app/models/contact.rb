require 'pardot/pardot'

class Contact < ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true
  has_many :subscriptions
  has_many :lists, through: :subscriptions

  def get_list_subscriptions
    subscriptions = []
    if Subscription.exists?(contact: self)
      Subscription.where(contact: self).each do |subscription|
        subscriptions.push({ id: subscription.list.pardot_id, title: subscription.list.title, description: subscription.list.description })
      end
    else
      @client = Pardot::Client.client

      begin
        @prospect = @client.prospects.read_by_fid(salesforce_id)

        @prospect['lists']['list_subscription'].each do |subscription|
          next unless subscription['list']['is_public'] == 'true'

          subscriptions.push({ id: subscription['list']['id'], title: subscription['list']['name'], description: subscription['list']['description'] })

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
    subscriptions
  end
end
