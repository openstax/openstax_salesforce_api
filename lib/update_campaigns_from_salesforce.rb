class UpdateCampaignsFromSalesforce
  def self.call
    new.start_update
  end

  def start_update
    sf_campaigns = retrieve_salesforce_data
    update_campaigns(sf_campaigns)
  end

  def retrieve_salesforce_data
    OpenStax::Salesforce::Remote::Campaign
        .select(:id, :name, :is_active)
        .to_a
  end

  def update_campaigns(sf_campaigns)
    sf_campaigns.each do |sf_campaign|
      campaign_to_update = Campaign.find_or_initialize_by(salesforce_id: sf_campaign.id)
      campaign_to_update.salesforce_id = sf_campaign.id
      campaign_to_update.name = sf_campaign.name
      campaign_to_update.is_active = sf_campaign.is_active

      campaign_to_update.save if campaign_to_update.changed?
    end
  end
end
