require 'rails_helper'

Sidekiq::Testing.inline!

RSpec.describe PushLeadToSalesforceJob, type: :job, vcr: VCR_OPTS do
  before(:all) do
    VCR.use_cassette('PushLeadToSalesforceJob/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :leads }
  it { is_expected.to be_retryable true }

  it 'pushes a lead' do
    fake_lead = FactoryBot.create :lead
    PushLeadToSalesforceJob.new.perform(fake_lead.id)
    expect(Lead.count).to be_nonzero
  end

  it 'updates the lead with the users account uuid' do
    fake_lead = FactoryBot.create :lead
    PushLeadToSalesforceJob.new.perform(fake_lead.id)
    found_lead = Lead.find_by_accounts_uuid(fake_lead.accounts_uuid)
    expect(found_lead.salesforce_id).to_not be_nil
  end
end
