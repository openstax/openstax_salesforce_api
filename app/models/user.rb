class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, if: :should_validate?

  private

    def should_validate?
      !password.blank? || new_record?
    end
  end


