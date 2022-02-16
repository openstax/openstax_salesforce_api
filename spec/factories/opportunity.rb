require 'faker'

FactoryBot.define do
  factory :opportunity, class: Opportunity do
    term_year { [ '2019 - 20 Spring', '2019 - 20 Fall', '2018 - 19 Fall', '2018 - 19 Spring'].sample }
    book_name { (FactoryBot.create :book).name }
    contact_id { 'not-set' }
    close_date { Date.today }
    stage_name { :won }
    type { :verified }
    number_of_students { Faker::Number.between(from: 1, to: 200) }
    student_number_status { 'Reported' }
    time_period { 'Year' }
    class_start_date { Date.today }
    school_id { '001U000001k36GVIAY' }
    book_id { '' }
    lead_source { 'Web' }
    os_accounts_id { 1 }
    name { Faker::Superhero.name }
    accounts_uuid { 'aaa560a1-e828-48fb-b9a8-d01e9aec71d0' }
  end
end
