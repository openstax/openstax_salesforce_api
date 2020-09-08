require 'faker'

FactoryBot.define do
  factory :api_contact, class: Contact do
    salesforce_id {Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
    name {Faker::Name.name }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.safe_email }
    email_alt { Faker::Internet.safe_email }
    faculty_confirmed_date { Faker::Date.between(from: '2016-09-23', to: '2019-09-25') }
    last_modified_at { Faker::Date.between(from: '2016-09-23', to: '2020-03-25') }
    school_id {Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
    school_type { ['High School','College/University (4)', 'K-12 School', 'Technical/Community College (2)', 'Career School/For-Profit (2)'].sample }
    send_faculty_verification_to { Faker::Internet.safe_email }
    all_emails { Faker::Internet.safe_email }
    confirmed_emails { Faker::Internet.safe_email }
    adoption_status { ['Confirmed Adoption Won', 'Confirmed Adoption Recommend', 'High Interest In Using', 'Not Using'].sample }
    grant_tutor_access { [false, true].sample }
  end
end
