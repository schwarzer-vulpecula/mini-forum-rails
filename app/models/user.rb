require 'securerandom'
require 'digest'

class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :username, format: { with: /\A[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\z/ }, length: { minimum: 3, maximum: 25}, uniqueness: true
  validates :password, confirmation: true, length: { minimum: 8, maximum: 24 }

  before_save :hash_password

  # Authenticates the password included with the password of this user
  def authenticate(password)
    password << self.salt
    password = Digest::SHA256.hexdigest password
    if password == self.password
      return true
    else
      return false
    end
  end

  # Returns the name that should be displayed (For now, just display the username)
  def name
     self.username
  end

  private
    # Hashes the password, using salts, so that it is not stored in plain text
    # This is not the most secure implementation
    def hash_password
      self.salt = SecureRandom.alphanumeric(16)
      self.password << self.salt
      self.password = Digest::SHA256.hexdigest self.password
    end
end
