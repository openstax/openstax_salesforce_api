class School < ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true

  def self.search(partial)
    where('name LIKE ?', "%#{partial}%")
  end
end
