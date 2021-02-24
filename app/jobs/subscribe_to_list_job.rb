class SubscribeToListJob < ApplicationJob
  queue_as :default

  def perform(list_pardot_id, contact_salesforce_id)
    @client = Pardot::Client.client

    prospect_id = salesforce_to_prospect(contact_salesforce_id)

    begin
      @client.list_memberships.create(list_pardot_id, prospect_id)
    rescue Pardot::ResponseError
      Rails.logger.info "#{contact_salesforce_id} already subscribed to list #{list_pardot_id}."
    end
  end

  def salesforce_to_prospect(salesforce_id)
    @client.prospects.read_by_fid(salesforce_id)['id']
  end
end
