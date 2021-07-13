class AccountContactRelation < ApplicationRecord
  has_many :schools, through: :schools
  has_many :contacts, through: :contacts

  validates_uniqueness_of :contact_id, scope: :school_id
end
