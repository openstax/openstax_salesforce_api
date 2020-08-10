require 'rails_helper'

RSpec.describe Opportunity, type: :model do
  subject(:opportunity) {FactoryBot.create :opportunity}
  it { is_expected.to be_valid}

  context "with opportunity" do
    it "creates opportunity" do
      expect(Opportunity.count).not_to be_an_zero
    end
  end
end
