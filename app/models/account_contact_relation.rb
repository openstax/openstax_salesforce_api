class AccountContactRelation < ApplicationRecord
  has_one :school
  has_one :contact

  before_validation :ensure_school_exists_in_api

  validates_uniqueness_of :contact_id, scope: :school_id

  private

  def ensure_school_exists_in_api
    return if School.find_by(salesforce_id: school_id).exists?

    sf_school = OpenStax::Salesforce::Remote::School.find_by!(school_id)
    School.cache_school(sf_school)
  end
end
