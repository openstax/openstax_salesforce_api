require 'rails_helper'

RSpec.describe School, type: :model do
  it "creates school" do
    school = FactoryBot.create :school
    expect(school).to be_valid

    expect(School.count).not_to be_an_zero
  end
end
