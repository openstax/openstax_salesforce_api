class List < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :contacts, through: :subscriptions
end
