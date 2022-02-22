require "sidekiq/enqueuer"

Rails.application.reloader.to_prepare do
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
end
