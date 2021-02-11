class List < ApplicationRecord
	has_many :user_list_subscriptions, dependent: :destroy
end
