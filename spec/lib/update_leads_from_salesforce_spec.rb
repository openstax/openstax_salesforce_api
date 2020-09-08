require 'rails_helper'
require 'update_leads_from_salesforce'

describe UpdateLeadsFromSalesforce do
  let(:ulfs) { UpdateLeadsFromSalesforce.new }

  it 'update leads' do
    stub_leads
    ulfs.update_leads(@sf_leads)

    expect Lead.count == @sf_leads.count
  end

  def stub_leads
    @sf_leads = FactoryBot.create_list('salesforce_lead', 12)
  end
end
