class Lead <ApplicationRecord
  #validates :salesforce_id, presence: true, uniqueness: true

  def self.search(os_accounts_id)
    where(os_accounts_id: os_accounts_id)
  end
end
