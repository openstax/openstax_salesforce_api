require 'rails_helper'
require 'update_contacts_from_salesforce'

describe UpdateContactsFromSalesforce do
  let(:ucfs) { UpdateContactsFromSalesforce.new }

  it 'update contacts' do
    stub_contacts
    ucfs.update_contacts(@sf_contacts)

    expect Contact.count == @sf_contacts.count
  end

  def stub_contacts
    @sf_contacts = FactoryBot.create_list('salesforce_contact', 12)
  end
end
