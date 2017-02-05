class User < ApplicationRecord
  has_secure_password
  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\Z/i

  validates :login, presence: true, length: { in: 3..20 }
  validates :email, presence: true, uniqueness: true, format: EMAIL_REGEX
  validates :status_code, presence: true
  validates :password, presence: true, length: { minimum: 6 }
end
