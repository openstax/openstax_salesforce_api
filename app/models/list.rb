class List < ApplicationRecord
  validates :pardot_id, presence: true, uniqueness: true

  has_many :subscriptions, dependent: :destroy
  has_many :contacts, through: :subscriptions
end
