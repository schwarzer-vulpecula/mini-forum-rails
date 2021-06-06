require 'digest'

class User < ApplicationRecord
  validates :username, format: { with: /\A[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\z/ }, length: { minimum: 3, maximum: 25}, uniqueness: true
  validates :password, confirmation: true, length: { minimum: 8, maximum: 24 }

  after_validation :hash_password, on: [ :create, :update ]

  private
    # Hashes the password, so that it is not stored in plain text
    # This is not the most secure implementation
    def hash_password
      self.password = Digest::SHA256.hexdigest password
    end
end
