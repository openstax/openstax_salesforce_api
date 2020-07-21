require 'rails_helper'

RSpec.describe Contact, type: :model do
  subject(:contact) {FactoryBot.create :contact}
  it { is_expected.to be_valid}

  context "with contact" do
    it "creates contact" do
      expect(Contact.count).not_to be_an_zero
    end
  end
end
