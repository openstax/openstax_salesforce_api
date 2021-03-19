class UpdateSchoolsFromSalesforce
  def self.call
    new.start_update
  end

  def start_update
    sf_schools = retrieve_salesforce_data
    update_schools(sf_schools)
  end

  def retrieve_salesforce_data
    OpenStax::Salesforce::Remote::School
        .select(:id, :name, :type, :school_location, :is_kip, :is_child_of_kip)
        .to_a
  end

  def update_schools(sf_schools)
    sf_schools.each do |sf_school|
      school_to_update = School.find_or_initialize_by(salesforce_id: sf_school.id)
      school_to_update.salesforce_id = sf_school.id
      school_to_update.name = sf_school.name
      school_to_update.school_type = sf_school.type
      school_to_update.location = sf_school.school_location
      school_to_update.is_kip = sf_school.is_kip
      school_to_update.is_child_of_kip = sf_school.is_child_of_kip

      school_to_update.save if school_to_update.changed?
    end
    delete_schools_removed_from_salesforce(sf_schools)
  end

  def delete_schools_removed_from_salesforce(sf_schools)
    sfapi_schools = School.all

    sfapi_schools.each do |sfapi_school|
      found = false
      sf_schools.each do |sf_school|
        found = true if sf_school.id == sfapi_school.salesforce_id
        break if found
      end
      School.destroy(sfapi_school.id) unless found
    end
  end
end
