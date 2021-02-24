class List < ApplicationRecord
  has_many :subscriptions
  has_many :contacts, through: :subscriptions
end
