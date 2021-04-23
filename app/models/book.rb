class Book < ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true

  def self.search(name)
    where(name: name)
  end
end
