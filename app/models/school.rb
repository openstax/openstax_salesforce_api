class School < ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true

  def self.search(name, limit)
    limit = 150 if limit.nil?
    where('name LIKE ?', "%#{name}%").limit(limit)
  end
end
