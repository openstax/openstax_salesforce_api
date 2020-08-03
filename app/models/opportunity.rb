class Opportunity <ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true
end
