class SyncSalesforceSchoolsJob < ApplicationJob
  queue_as :schools
  sidekiq_options lock: :while_executing,
                  on_conflict: :reject

  def perform(*args)
    sf_schools = OpenStax::Salesforce::Remote::School.all

    store schools_syncing: sf_schools.count

    sf_schools.each do |sf_school|
      School.cache_local(sf_school)
    end
    JobsHelper.delete_objects_not_in_salesforce('School', sf_schools)
  end
end

if Sidekiq.server?
  Sidekiq::Cron::Job.create(name: 'Salesforce School sync - every 1 day', cron: '0 0 * * *', class: 'SyncSalesforceSchoolsJob')
end
