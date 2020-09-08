require 'rails_helper'

RSpec.describe Campaign, type: :model do
  subject(:campaign) {FactoryBot.create :api_campaign}
  it { is_expected.to be_valid}

  context "with campaign" do
    it "creates campaign" do
      expect(Campaign.count).not_to be_an_zero
    end
  end
end
