require 'securerandom'
require 'digest'

class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :username, format: { with: /\A[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\z/ }, length: { minimum: 3, maximum: 25}, uniqueness: true
  validates :password, confirmation: true, length: { minimum: 8, maximum: 24 }, if: -> { self.salt.nil? }
  validates :display_name, length: { maximum: 30 }, format: { without: /@/ }

  before_save :hash_password, if: -> { self.salt.nil? }

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

  # Returns the name that should be displayed
  def name
     if display_name.blank?
       '@' << self.username
     else
       self.display_name
     end
  end

  # Like above, but it will always include the username
  def complete_name
    if display_name.blank?
      name
    else
      return self.display_name + ' (@' + self.username + ')'
    end
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
