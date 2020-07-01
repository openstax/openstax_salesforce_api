require 'rails_helper'

RSpec.describe School, type: :model do
  subject(:school) {FactoryBot.create :school}
  it { is_expected.to be_valid}

  context "with school" do
    it "creates school" do
      expect(School.count).not_to be_an_zero
    end
  end
end
