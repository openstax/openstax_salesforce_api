require 'rails_helper'
require 'vcr_helper'
Sidekiq::Testing.inline!

RSpec.describe SyncSalesforceJob, type: :job, vcr: VCR_OPTS do
  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable 1 }

  it 'syncs books' do
    SyncSalesforceJob.new.perform(['Book'])

    expect(Book.count).to be > 1
  end

  it 'syncs campaigns and campaign members' do
    SyncSalesforceJob.new.perform(['Campaign', 'CampaignMember'])

    expect(Campaign.count).to be > 1
    expect(CampaignMember.count).to be > 1
  end

  it 'handles wrong parameter by doing nothing' do
    SyncSalesforceJob.new.perform(['Junk'])
  end
end
