require 'faker'

FactoryBot.define do
  factory :opportunity, class: Opportunity do
    term_year { [ '2019 - 20 Spring', '2019 - 20 Fall', '2018 - 19 Fall', '2018 - 19 Spring'].sample }
    book_name { 'set-me-on-init' }
    #contact_id { 'not-set' }
    close_date { Date.today }
    stage_name { :won }
    update_type { :new_business }
    number_of_students { Faker::Number.between(from: 1, to: 200) }
    student_number_status { 'Reported' }
    time_period { 'Year' }
    class_start_date { Date.today }
    #school_id { SFAPISupport::SFSpecHelpers.a_school_from_salesforce.id }
    #book_id { SFAPISupport::SFSpecHelpers.a_book_from_salesforce.id }
    name { Faker::Superhero.name }
    accounts_uuid { 'aaa560a1-e828-48fb-b9a8-d01e9aec71d0' }
  end
end
