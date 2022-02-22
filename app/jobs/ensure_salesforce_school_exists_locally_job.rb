class EnsureSalesforceSchoolExistsLocallyJob < ApplicationJob
  queue_as :schools

  def perform(school_id)
    return if School.find_by(salesforce_id: school_id).present?
    sf_school = OpenStax::Salesforce::Remote::School.find_by(id: school_id)
    if sf_school
      School.cache_local(sf_school)
    else
      # TODO: Let's just make the school...? Although this should not be happening unless it's a cross-env issue
      # for now, making sure this error is raised on prod and staging - will ignore on dev/qa
      if Rails.application.is_real_production?  || Rails.application.is_staging?
        raise(SchoolDoesNotExistInSalesforce)
      end
    end
  end
end
