require 'rails_helper'
require 'update_opportunities_from_salesforce'

describe UpdateOpportunitiesFromSalesforce do
  let(:uofs) { UpdateOpportunitiesFromSalesforce.new }

  it 'update opportunities' do
    stub_opportunities
    uofs.update_opportunities(@sf_opportunities)

    expect Opportunity.count == @sf_opportunities.count
  end

  def stub_opportunities
    @sf_opportunities = FactoryBot.create_list('opportunity', 12)
  end
end
