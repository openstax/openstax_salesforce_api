require 'faker'

FactoryBot.define do
  factory :api_new_opportunity, class: Opportunity do
    term_year { [ '2019 - 20 Spring', '2019 - 20 Fall', '2018 - 19 Fall', '2018 - 19 Spring'].sample }
    book_name { 'Prealgebra' }
    contact_id { '0034C00000T6UZLQA3' }
    new { [true, false].sample }
    close_date { Date.today }
    stage_name { 'Confirm Adoption Won' }
    update_type { 'Renewal - Verified' }
    number_of_students { Faker::Number.between(from: 1, to: 200) }
    student_number_status { 'Reported' }
    time_period { 'Year' }
    class_start_date { Date.today }
    school_id { '0014C00000ZiK4nQAF' }
    book_id { '' }
    lead_source { 'Web' }
    os_accounts_id { 1 }
    name { Faker::Superhero.name }
  end
end
