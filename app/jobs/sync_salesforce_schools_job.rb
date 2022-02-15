class SyncSalesforceSchoolsJob < ApplicationJob
  sidekiq_options lock: :while_executing,
                  on_conflict: :reject

  def perform(salesforce_id: nil)
    if salesforce_id
      sf_schools = OpenStax::Salesforce::Remote::School.where(salesforce_id: salesforce_id)
    else
      sf_schools = OpenStax::Salesforce::Remote::School.all
    end

    sf_schools.each do |sf_school|
      school = School.cache_school(sf_school)
      return school if sf_schools.count == 1
    end
    JobsHelper.delete_objects_not_in_salesforce('School', sf_schools)
  end
end

# if Sidekiq.server?
#   Sidekiq::Cron::Job.create(name: 'Salesforce School sync - every 1 day', cron: '0 0 * * *', class: 'SyncSalesforceSchoolsJob')
# end
