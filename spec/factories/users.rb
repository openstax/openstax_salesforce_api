FactoryBot.define do
  factory :user do
    username { "MyString" }
    password_digest { "MyString" }
    has_access { false }
    is_admin { false }
  end
end
