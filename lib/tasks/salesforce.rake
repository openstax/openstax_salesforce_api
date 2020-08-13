require 'update_books_from_salesforce'
require 'update_campaign_members_from_salesforce'
require 'update_campaigns_from_salesforce'
require 'update_contacts_from_salesforce'
require 'update_leads_from_salesforce'
require 'update_opportunities_from_salesforce'
require 'update_schools_from_salesforce'

namespace :salesforce do
  desc 'Update books from Salesforce'
  task 'update_books' => :environment do
    puts "update_books task: started"
    UpdateBooksFromSalesforce.call
    puts "update_books task: completed"
  end

  desc 'Update campaign members from Salesforce'
  task 'update_campaign_members' => :environment do
    puts "update_campaign_members task: started"
    UpdateCampaignMembersFromSalesforce.call
    puts "update_campaign_members task: completed"
  end

  desc 'Update campaigns from Salesforce'
  task 'update_campaigns' => :environment do
    puts "update_campaigns task: started"
    UpdateCampaignsFromSalesforce.call
    puts "update_campaigns task: completed"
  end

  desc 'Update contacts from Salesforce'
  task 'update_contacts' => :environment do
    puts "update_contacts task: started"
    UpdateContactsFromSalesforce.call
    puts "update_contacts task: completed"
  end

  desc 'Update leads from Salesforce'
  task 'update_leads' => :environment do
    puts "update_leads task: started"
    UpdateLeadsFromSalesforce.call
    puts "update_leads task: completed"
  end

  desc 'Update opportunities from Salesforce'
  task 'update_opportunities' => :environment do
    puts "update_opportunities task: started"
    UpdateOpportunitiesFromSalesforce.call
    puts "update_opportunities task: completed"
  end

  desc 'Update schools from Salesforce'
  task 'update_schools' => :environment do
    puts "update_schools task: started"
    UpdateSchoolsFromSalesforce.call
    puts "update_schools task: completed"
  end

  desc 'Update all data from Salesforce'
  task 'update_all' => ["salesforce:update_books", "salesforce:update_campaign_members", "salesforce:update_campaigns", "salesforce:update_contacts", "salesforce:update_leads", "salesforce:update_opportunities", "salesforce:update_schools"] do
    puts "update_all task: completed"
  end
end
