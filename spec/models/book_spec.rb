require 'rails_helper'

RSpec.describe Book, type: :model do
  it "creates book" do
    book = FactoryBot.create :book
    expect(book).to be_valid

    expect(Book.count).not_to be_an_zero
  end
end
