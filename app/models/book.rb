class Book < ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true
end
