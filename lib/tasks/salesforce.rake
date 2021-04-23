namespace :salesforce do
  desc 'Sync data with Salesforce'
  task 'sync_salesforce' => :environment do
    puts "sync_salesforce task: started in background"
    SyncSalesforceJob.perform_later
  end
end
