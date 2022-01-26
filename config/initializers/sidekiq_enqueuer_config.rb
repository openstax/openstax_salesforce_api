require 'sidekiq/enqueuer'

Rails.application.reloader.to_prepare do
	Sidekiq::Enqueuer.configure do |config|
		config.jobs = [SyncSalesforceJob, SyncPardotJob, SyncSalesforceContactsJob, SyncSalesforceOpportunitiesJob, SyncSalesforceContactSchoolRelationsJob]
	end
end
