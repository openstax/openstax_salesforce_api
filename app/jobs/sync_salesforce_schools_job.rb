class SyncSalesforceSchoolsJob < ApplicationJob
  sidekiq_options lock: :while_executing,
                  on_conflict: :reject

  def perform(*args)
    sf_schools = OpenStax::Salesforce::Remote::School.all

    sf_schools.each do |sf_school|
      school = School.find_or_initialize_by(salesforce_id: sf_school.id)
      school.salesforce_id = sf_school.id
      school.name = sf_school.name
      school.city = sf_school.city
      school.state = sf_school.state
      school.country = sf_school.country
      school.school_type = sf_school.type
      school.location = sf_school.school_location
      school.is_kip = sf_school.is_kip
      school.is_child_of_kip = sf_school.is_child_of_kip
      school.total_school_enrollment = sf_school.total_school_enrollment

      school.save if school.changed?
    end
  end
end

if Sidekiq.server?
  Sidekiq::Cron::Job.create(name: 'Salesforce School sync - every 1 day', cron: '0 0 * * *', class: 'SyncSalesforceSchoolsJob')
end
