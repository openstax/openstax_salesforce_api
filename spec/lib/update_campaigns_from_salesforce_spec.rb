require 'rails_helper'
require 'update_campaigns_from_salesforce'

describe UpdateCampaignsFromSalesforce do
  let(:ucfs) { UpdateCampaignsFromSalesforce.new }

  it 'update campaigns' do
    stub_campaigns
    ucfs.update_campaigns(@sf_campaigns)

    expect Campaign.count == @sf_campaigns.count
  end

  def stub_campaigns
    @sf_campaigns = FactoryBot.create_list('salesforce_campaign', 12)
  end
end
