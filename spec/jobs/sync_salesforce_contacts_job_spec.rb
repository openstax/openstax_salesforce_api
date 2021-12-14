require 'rails_helper'
require 'vcr_helper'
Sidekiq::Testing.inline!

RSpec.describe SyncSalesforceContactsJob, type: :job, vcr: VCR_OPTS do
	before(:each) do
		Sidekiq::Worker.clear_all
  end

	before(:all) do
		VCR.use_cassette('SyncSalesforceContactsJob/sf_setup', VCR_OPTS) do
			@proxy = SalesforceProxy.new
			@proxy.setup_cassette
		end
	end

	it { is_expected.to be_processed_in :default }
	it { is_expected.to be_retryable true }

	it 'syncs contacts' do
		SyncSalesforceContactsJob.new.perform()

		expect(Contact.count).to be > 0
	end

	it 'syncs one contact' do
		SyncSalesforceContactsJob.new.perform('e93dc9b8-36b8-403b-9aa6-f8966e239490')

		expect(Contact.where(salesforce_id: '0034C00000WkwxbQAB')).to exist
	end
end
