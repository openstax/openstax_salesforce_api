require 'rails_helper'

RSpec.describe Book, type: :model do
  subject(:book) {FactoryBot.create :api_book}
  it { is_expected.to be_valid}

  context "with book" do
    it "creates book" do
      expect(Book.count).not_to be_an_zero
    end
  end
end
