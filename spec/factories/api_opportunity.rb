require 'faker'

FactoryBot.define do
  factory :api_opportunity, class: Opportunity, aliases: [:opportunity] do
    term_year { [ '2019 - 20 Spring', '2019 - 20 Fall', '2018 - 19 Fall', '2018 - 19 Spring'].sample }
    book_name { 'Prealgebra' }
    contact_id { '003U000001t59XgIAI' }
    new { [true, false].sample }
    close_date { Date.today }
    stage_name { 'Confirm Adoption Won' }
    update_type { 'Renewal - Verified' }
    number_of_students { Faker::Number.between(from: 1, to: 200) }
    student_number_status { 'Reported' }
    time_period { 'Year' }
    class_start_date { Date.today }
    school_id { '001U000001k36GVIAY' }
    book_id { '' }
    lead_source { 'Web' }
    os_accounts_id { 1 }
    name { Faker::Superhero.name }
    record_type_name { 'Book Opp' }
    record_type_id { Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3) }
    accounts_uuid { 'aaa560a1-e828-48fb-b9a8-d01e9aec71d0' }
  end
end
