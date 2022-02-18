require 'rails_helper'

RSpec.describe Opportunity, type: :model do
  it "creates opportunity" do
    opportunity = FactoryBot.create :opportunity
    expect(opportunity).to be_valid

    expect(Opportunity.count).not_to be_an_zero
  end
end
