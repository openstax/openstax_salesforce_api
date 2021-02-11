require 'pardot/pardot'

class UpdateListsFromPardot

  def self.call
    new.start_update
  end

  def start_update
    pardot_secrets = Rails.application.secrets.pardot
    @client = Pardot::Client.new pardot_secrets[:email], pardot_secrets[:password], pardot_secrets[:user_key]
    @client.authenticate

    lists = @client.lists.query(is_greater_than: 0)
    lists['list'].each do |list|
      next unless list['is_public'] == 'true'

      @pardot_list = List.where(pardot_id: list['id']).first_or_create do |plist|
        plist.title = list['title']
        plist.description = list['description']
      end
    end
  end
end