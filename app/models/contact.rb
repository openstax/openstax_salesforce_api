class Contact < ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true
  has_many :subscriptions, dependent: :destroy
  has_many :lists, through: :subscriptions

  def self.search(email)
    where(email: email)
  end
end
