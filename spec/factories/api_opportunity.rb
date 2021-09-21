require 'faker'
require 'time'

FactoryBot.define do
  factory :api_opportunity, class: Opportunity do
    salesforce_id { '0067h00000Brg8EAAR' }
    term_year { [ '2019 - 20 Spring', '2019 - 20 Fall', '2018 - 19 Fall', '2018 - 19 Spring'].sample }
    book_name { 'Managerial Accounting' }
    contact_id { '003U000001t59YjIAI' }
    new { false }
    close_date { Date.today - 2 }
    stage_name { 'Confirm Adoption Won' }
    update_type { 'Renewal - Verified' }
    number_of_students { Faker::Number.between(from: 1, to: 200) }
    student_number_status { 'Reported' }
    time_period { 'Year' }
    school_id { '001U000001QYuEjIAL' }
    book_id { 'a0ZU000000IgKrdMAF' }
    lead_source { 'Web' }
  end
end
