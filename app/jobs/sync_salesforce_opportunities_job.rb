class SyncSalesforceOpportunitiesJob < ApplicationJob
  queue_as :default

  BATCH_SIZE = 250

  def perform(contact_id=nil)
    last_id = nil
    loop do
      if contact_id
        sf_opportunities = OpenStax::Salesforce::Remote::Opportunity.where(contact_id:contact_id)
      else
        sf_opportunities = OpenStax::Salesforce::Remote::Opportunity.group(:id).order(:id).limit(BATCH_SIZE)
        sf_opportunities = sf_opportunities.where("id > '#{last_id}'") unless last_id.nil?
        #sf_opportunities = sf_opportunities.to_a
        last_id = sf_opportunities.last.id unless sf_opportunities.last.nil?
        puts sf_opportunities.count.inspect
      end

      sf_opportunities.each do |sf_opportunity|
        opportunity_to_update = Opportunity.find_or_initialize_by(salesforce_id: sf_opportunity.id)
        opportunity_to_update.salesforce_id = sf_opportunity.id
        opportunity_to_update.term_year = sf_opportunity.term_year
        opportunity_to_update.book_name = sf_opportunity.book_name
        opportunity_to_update.contact_id = sf_opportunity.contact_id
        opportunity_to_update.new = sf_opportunity.new
        opportunity_to_update.close_date = sf_opportunity.close_date
        opportunity_to_update.stage_name = sf_opportunity.stage_name
        opportunity_to_update.update_type = sf_opportunity.type
        opportunity_to_update.number_of_students = sf_opportunity.number_of_students
        opportunity_to_update.student_number_status = sf_opportunity.student_number_status
        opportunity_to_update.time_period = sf_opportunity.time_period
        opportunity_to_update.class_start_date = sf_opportunity.class_start_date
        opportunity_to_update.school_id = sf_opportunity.school_id
        opportunity_to_update.book_id = sf_opportunity.book_id
        opportunity_to_update.lead_source = sf_opportunity.lead_source
        opportunity_to_update.os_accounts_id = sf_opportunity.os_accounts_id
        opportunity_to_update.name = sf_opportunity.name

        opportunity_to_update.save if opportunity_to_update.changed?
      end
      break if sf_opportunities.length < BATCH_SIZE
    end
  end
end

if Sidekiq.server?
  Sidekiq::Cron::Job.create(name: 'Salesforce opportunities sync - every 1 hour', cron: '0 */1 * * *', class: 'SyncSalesforceOpportunitiesJob')
end
