require "sidekiq/enqueuer"

Sidekiq::Enqueuer.configure do |config|
  config.jobs = [SyncSalesforceSchoolsJob,
                 SyncSalesforceContactsJob,
                 SyncSalesforceLeadsJob,
                 SyncSalesforceBooksJob,
                 SyncPardotJob,
                 SyncSalesforceOpportunitiesJob,
                 SyncContactSchoolsToSalesforceJob,
                 SyncSalesforceContactSchoolRelationsJob]
end
