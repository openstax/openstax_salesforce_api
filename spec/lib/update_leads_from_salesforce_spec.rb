require 'rails_helper'
require 'update_leads_from_salesforce'

describe UpdateLeadsFromSalesforce do
  let(:ulfs) { UpdateLeadsFromSalesforce.new }

  it 'update leads' do
    stub_leads
    ulfs.update_leads(@sf_leads, @leads)

    expect Lead.count == @leads.count
  end

  it 'create new leads' do
    stub_leads
    ulfs.create_new_leads(@sf_leads, @leads)

    expect Lead.count == @sf_leads.count
  end

  def stub_leads
    @leads = FactoryBot.create_list('lead', 10)
    @sf_leads = @leads.dup + FactoryBot.create_list('lead', 2)
  end
end