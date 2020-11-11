require 'faker'

FactoryBot.define do
  factory :api_opportunity, class: Opportunity do
    salesforce_id { '0067X000007eQMeQAM' }
    term_year { [ '2019 - 20 Spring', '2019 - 20 Fall', '2018 - 19 Fall', '2018 - 19 Spring'].sample }
    book_name {Faker::Book.title}
    contact_id { '003U000001hcCzuIAE' }
    new { [true, false].sample}
    close_date { Date.today }
    stage_name { "Confirm Adoption Won" }
    update_type { "Renewal - Verified" }
    number_of_students { Faker::Number.between(from: 1, to: 200)}
    student_number_status { "Reported" }
    time_period { 'Year' }
    class_start_date { Date.today }
    school_id { '001U0000007gj6EIAQ' }
    book_id { Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3) }
    lead_source { 'openstax-salesforce-api' }
    os_accounts_id { 1 }
    name { 'Bogus Name' }
  end
end
