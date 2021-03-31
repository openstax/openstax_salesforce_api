namespace :pardot do
  desc 'Sync lists and subscriptions with Pardot'
  task 'sync_pardot' => :environment do
    puts 'Pardot sync started in background'
    SyncPardotJob.perform_later
  end
end
