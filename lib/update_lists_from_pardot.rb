class UpdateListsFromPardot

  def self.call
    new.start_update
  end

  def start_update
    existing_lists = List.pluck(:pardot_id)
    new_lists = []

    lists = Pardot.client.lists.query(is_greater_than: 0)
    lists['list'].each do |list|
      next unless list['is_public'] == 'true'

      new_lists.append(list['id'].to_i)
      @pardot_list = List.where(pardot_id: list['id']).first_or_create do |plist|
        plist.title = list['title']
        plist.description = list['description']
      end
    end

    # remove lists if they no longer exist in Pardot
    existing_lists.each do |existing_list_pardot_id|
      List.destroy_by(pardot_id: existing_list_pardot_id) unless new_lists.include? existing_list_pardot_id
    end

  end
end
