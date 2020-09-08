require 'rails_helper'
require 'update_campaign_members_from_salesforce'

describe UpdateCampaignMembersFromSalesforce do
  let(:ucmfs) { UpdateCampaignMembersFromSalesforce.new }

  it 'update campaign members' do
    stub_campaign_members
    ucmfs.update_campaign_members(@sf_campaign_members)

    expect CampaignMember.count == @sf_campaign_members.count
  end

  def stub_campaign_members
    @sf_campaign_members = FactoryBot.create_list('salesforce_campaign_member', 12)
  end
end
