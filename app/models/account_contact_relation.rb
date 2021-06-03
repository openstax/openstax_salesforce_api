class AccountContactRelation < ApplicationRecord
  has_many :schools, through: :schools
  has_many :contacts, through: :contacts
end
