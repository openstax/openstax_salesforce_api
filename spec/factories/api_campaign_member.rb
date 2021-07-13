require 'faker'

FactoryBot.define do
  factory :api_campaign_member, class: CampaignMember do
    salesforce_id { Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3) }
    campaign_id { Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3) }
    contact_id { FactoryBot.create(:api_contact).salesforce_id }
    accounts_uuid { Faker::Internet.uuid }
    pardot_reported_contact_id { Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3) }
    pardot_reported_piaid { Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3) }
    pardot_reported_picid  { Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3) }
    first_teacher_contact_id { Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3) }
    arrived_marketing_page_from_pardot_at { Faker::Date.between(from: '2016-09-23', to: '2019-09-25') }
    arrived_marketing_page_not_from_pardot_at { Faker::Date.between(from: '2016-09-23', to: '2019-09-25') }
    first_arrived_my_courses_at { Faker::Date.between(from: '2016-09-23', to: '2019-09-25') }
    preview_created_at { Faker::Date.between(from: '2016-09-23', to: '2019-09-25') }
    real_course_created_at { Faker::Date.between(from: '2016-09-23', to: '2019-09-25') }
    like_preview_ask_later_count { Faker::Number.within(range: 1..99) }
    like_preview_yes_at { Faker::Date.between(from: '2016-09-23', to: '2019-09-25') }
    latest_adoption_decision { ['Confirmed Adoption Won', 'Confirmed Adoption Recommend', 'High Interest In Using', 'Not Using'].sample }
    latest_adoption_decision_at { Faker::Date.between(from: '2016-09-23', to: '2019-09-25') }
    estimated_enrollment { Faker::Number.within(range: 1..500) }
    ignored_osas { [false, true].sample }
    percent_enrolled { Faker::Number.within(range: 1..100) }
    school_type { ['High School','College/University (4)', 'K-12 School', 'Technical/Community College (2)', 'Career School/For-Profit (2)'].sample }
    students_registered { Faker::Number.within(range: 1..500) }
    students_reported_by_teacher { Faker::Number.within(range: 1..500) }
    students_with_work { Faker::Number.within(range: 1..100) }
    sync_field { Faker::Date.between(from: '2016-09-23', to: '2019-09-25') }

  end
end
