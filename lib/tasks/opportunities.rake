require 'retry_failed_opportunities'

namespace :opportunities do
  desc 'retry sending failed opportunities to Salesforce'
  task 'retry' => :environment do
    puts "retry task: started"
    RetryFailedOpportunities.call
    puts "retry task: completed"
  end
end
