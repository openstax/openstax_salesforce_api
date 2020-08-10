require 'rails_helper'

RSpec.describe CampaignMember, type: :model do
  subject(:campaign_member) {FactoryBot.create :campaign_member}
  it { is_expected.to be_valid}

  context "with campaign member" do
    it "creates campaign member" do
      expect(CampaignMember.count).not_to be_an_zero
    end
  end
end
