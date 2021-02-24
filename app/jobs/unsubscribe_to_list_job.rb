class UnsubscribeToListJob < ApplicationJob
  queue_as :default

  def perform(list_pardot_id, contact_salesforce_id)
    @client = Pardot::Client.client

    prospect_id = salesforce_to_prospect(contact_salesforce_id)

    begin
      @client.list_memberships.delete(list_pardot_id, prospect_id)
    rescue NoMethodError # for some reason successful deletion returns NoMethodError
      Rails.logger.info "Successfully deleted #{contact_salesforce_id} from #{list_pardot_id}"
    end
  end

  def salesforce_to_prospect(salesforce_id)
    @client.prospects.read_by_fid(salesforce_id)['id']
  end
end
