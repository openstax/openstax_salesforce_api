require 'rails_helper'
require_relative '../../lib/update_leads_from_salesforce'

describe UpdateLeadsFromSalesforce do
  let(:ulfs) { UpdateLeadsFromSalesforce.new }

  # before(:each) do
  #   ulfs.retrieve_salesforce_and_lead_data
  # end

  it 'start update' do
    ulfs.start_update

    expect Lead.count > 0
  end

  def stub_salesforce(leads: [])
    stub_leads(leads)
  end

  def stub_leads(leads)
    leads = [leads].flatten.map do |lead|
      case lead
      when OpenStax::Salesforce::Remote::Lead
        lead
      when Hash
        OpenStax::Salesforce::Remote::Lead.new(
            id: lead[:id] || SecureRandom.hex(10),
            email: lead[:email],
            status: lead[:status]
        )
      end
    end

    expect_any_instance_of(described_class).to receive(:leads) { leads }
  end
end