require 'rails_helper'

Sidekiq::Testing.inline!

RSpec.describe SyncSalesforceOpportunitiesJob, type: :job, vcr: VCR_OPTS do
  before(:all) do
    VCR.use_cassette('SyncSalesforceOpportunitiesJob/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  before(:each) do
    Sidekiq::Worker.clear_all
  end

  describe 'testing worker' do
    it 'ActionItemWorker jobs are enqueued in the scheduled queue' do
      described_class.perform_async
      assert_equal "opportunities", described_class.queue
    end
  end
end
