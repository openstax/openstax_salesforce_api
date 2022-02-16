class AccountContactRelation < ApplicationRecord
  has_one :school
  has_one :contact

  before_validation :ensure_school_exists_in_api

  validates_uniqueness_of :contact_id, scope: :school_id

  # expects an object of type
  # OpenStax::Salesforce::Remote::AccountContactRelation
  def self.cache_local(sf_relation)
    relation = AccountContactRelation.find_or_initialize_by(contact_id: sf_relation.contact_id, school_id: sf_relation.school_id)
    relation.salesforce_id = sf_relation.id
    relation.contact_id = sf_relation.contact_id
    relation.school_id = sf_relation.school_id
    relation.primary = sf_relation.primary

    relation.save if relation.changed?
  end

  private

  def ensure_school_exists_in_api
    return if School.exists?(salesforce_id: self.salesforce_id)
    SyncSalesforceSchoolsJob.perform_inline(school_id)
  end
end
