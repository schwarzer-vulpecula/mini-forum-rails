class User < ApplicationRecord
  validates :username, format: { with: /\A[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\z/ }, length: { minimum: 3, maximum: 25}, uniqueness: true
  validates :password, confirmation: true, length: { minimum: 8, maximum: 24 }
end
