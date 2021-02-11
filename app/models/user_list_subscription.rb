class UserListSubscription < ApplicationRecord
	belongs_to :list
	belongs_to :contact
end
