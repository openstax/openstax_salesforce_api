class Subscription < ApplicationRecord
  belongs_to :contact
  belongs_to :list

  enum status: %i[pending_create created pending_destroy]
end
