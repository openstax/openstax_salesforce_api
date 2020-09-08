require 'faker'

FactoryBot.define do
  factory :api_opportunity, class: Opportunity do
    salesforce_id {Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
    term_year { [ '2019 - 20 Spring', '2019 - 20 Fall', '2018 - 19 Fall', '2018 - 19 Spring'].sample }
    book_name {Faker::Book.title}
    contact_id {Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
    new { [true, false].sample}
  end
end
