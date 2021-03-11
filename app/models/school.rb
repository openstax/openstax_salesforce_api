class School < ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true

  def self.search(name)
    where('name LIKE ?', "%#{name}%")
  end
end
