class Subscription < ApplicationRecord
  belongs_to :contact
  belongs_to :list

  enum status: %i[pending_create created pending_destroy]

  after_initialize do
    self.status ||= :pending_create if new_record?
  end
end
