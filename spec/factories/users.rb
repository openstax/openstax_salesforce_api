require 'faker'

FactoryBot.define do
  factory :user do
    username {Faker::Name.name }
    password_digest { "MyString" }
    has_access { true }
    is_admin { false }
  end
end
