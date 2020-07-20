class Lead <ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true
end
