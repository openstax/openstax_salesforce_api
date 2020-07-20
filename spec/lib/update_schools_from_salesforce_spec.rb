require 'rails_helper'
require 'update_schools_from_salesforce'

describe UpdateSchoolsFromSalesforce do
  let(:usfs) { UpdateSchoolsFromSalesforce.new }

  it 'update schools' do
    stub_schools
    usfs.update_schools(@sf_schools)

    expect School.count == @sf_schools.count
  end

  def stub_schools
    @sf_schools = FactoryBot.create_list('school', 12)
  end
end
