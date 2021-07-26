require 'sidekiq/enqueuer'

Sidekiq::Enqueuer.configure do |config|
	config.jobs = [SyncSalesforceJob, SyncPardotJob]
end
