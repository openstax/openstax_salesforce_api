class Subscription < ApplicationRecord
  belongs_to :contact
  belongs_to :list

  enum status: %i[pending complete]
end
