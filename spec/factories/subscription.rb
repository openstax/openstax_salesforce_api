require 'faker'

FactoryBot.define do
  factory :subscription, class: Subscription do
    list
    contact
    status { 0 }
  end
end
