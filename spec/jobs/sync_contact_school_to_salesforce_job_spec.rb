require 'rails_helper'

Sidekiq::Testing.inline!

RSpec.describe SyncContactSchoolsToSalesforceJob, type: :job, vcr: VCR_OPTS do
  before(:all) do
    VCR.use_cassette('SyncContactSchoolsToSalesforceJob/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :schools }
  it { is_expected.to be_retryable true }

  it 'school is added by job' do
    # SyncContactSchoolsToSalesforceJob.new.perform(@new_relation, 'add')
    # expect(AccountContactRelation.last.contact_id).to eq(@new_relation.contact_id)
    pending("Need to implement")
    raise "Not Implemented"
  end

  it 'school is removed by job' do
    # SyncContactSchoolsToSalesforceJob.new.perform(@new_relation, 'remove')
    # expect(AccountContactRelation.find_by(contact_id: @new_relation.contact_id)).to be nil
    pending("Need to implement")
    raise "Not Implemented"
  end

  it 'school is updated by job' do
    # SyncContactSchoolsToSalesforceJob.new.perform(@new_relation, 'update')
    # sf_contact = OpenStax::Salesforce::Remote::Contact.find_by(id: @new_relation.contact_id)
    # expect(sf_contact.school_id).to eq(@new_relation.school_id)
    pending("Need to implement")
    raise "Not Implemented"
  end
end
