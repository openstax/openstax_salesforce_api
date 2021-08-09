require 'rails_helper'
require 'vcr_helper'
require 'spec_helper'

Sidekiq::Testing.inline!

RSpec.describe SyncContactSchoolsToSalesforceJob, type: :job do
  before(:each) do
    Sidekiq::Worker.clear_all
  end

  before(:all) do
    VCR.use_cassette('SyncContactSchoolToSalesforceJob/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
    @new_relation = FactoryBot.create(:api_account_contact_relation, contact_id: '0034C00000T6UZ5QAN', school_id: '0014C00000ZiKgfQAF' )
  end


  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable true }

  it 'school is added by job' do
    SyncContactSchoolsToSalesforceJob.new.perform(@new_relation, 'add')
    expect(AccountContactRelation.last.contact_id).to eq(@new_relation.salesforce_id)
  end

  it 'school is removed by job' do
    SyncContactSchoolsToSalesforceJob.new.perform(@new_relation, 'remove')
    expect(AccountContactRelation.count).to be 0
  end

  it 'school is updated by job' do
    SyncContactSchoolsToSalesforceJob.new.perform(@new_relation, 'update')
    expect(Contact.where(school_id: @new_relation.school_id)).to exist
  end
end
