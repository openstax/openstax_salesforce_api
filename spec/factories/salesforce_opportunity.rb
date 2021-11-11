require 'faker'

FactoryBot.define do
  factory :salesforce_opportunity, class: OpenStax::Salesforce::Remote::Opportunity do
    skip_create
    id {Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
    term_year { [ '2019 - 20 Spring', '2019 - 20 Fall', '2018 - 19 Fall', '2018 - 19 Spring'].sample }
    book_name {Faker::Book.title}
    contact_id {Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
    new { [true, false].sample}
    close_date { Date.today }
    stage_name { "Confirm Adoption Won" }
    type { "Renewal - Verified" }
    number_of_students { Faker::Number.between(from: 1, to: 200)}
    student_number_status { "Reported" }
    time_period { 'Year' }
    class_start_date { Date.today }
    school_id {Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
    book_id {Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
    lead_source { 'openstax-salesforce-api' }
    os_accounts_id { Faker::Number.number(digits: 10) }
    name { 'Bogus Name' }
    record_type_name { 'Book Opp' }
    record_type_id { '0120B000000NAH0QAO' }
  end
end
