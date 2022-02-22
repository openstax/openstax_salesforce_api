require 'rails_helper'
require 'spec_helper'
require 'vcr_helper'

RSpec.describe Contact, type: :model do
  it "creates contact" do
    contact = FactoryBot.create :contact
    expect(contact).to be_valid

    expect(Contact.count).not_to be_an_zero
  end
end
