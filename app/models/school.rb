class School < ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true
  has_many :account_contact_relations

  def self.search(name, limit)
    limit = 150 if limit.nil?
    where('lower(name) LIKE ?', "%#{name}%".downcase).limit(limit)
  end

  # expects an object of type
  # OpenStax::Salesforce::Remote::School
  def self.cache_local(sf_school)
    school = School.find_or_initialize_by(salesforce_id: salesforce_id)
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
    school
  end
end
