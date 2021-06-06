class User < ApplicationRecord
  validates :username, format: { with: /\A[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\z/ }
  validates :password, confirmation: true, length: { minimum: 8 }
end
