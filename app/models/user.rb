require 'securerandom'
require 'digest'

class User < ApplicationRecord
  enum avatar: { 'corsac' => 0, 'ferrilata' => 1, 'lagopus' => 2, 'macrotis' => 3, 'silver' => 4, 'stenognathus' => 5, 'velox' => 6, 'vulpes-schrencki' => 7, 'zerda' => 8 }
  enum rank: { 'user' => 1, 'moderator' => 2, 'administrator' => 3 }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :replies, dependent: :destroy

  validates :username, format: { with: /\A[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\z/ }, length: { minimum: 3, maximum: 25}, uniqueness: true
  validates :password, confirmation: true, length: { minimum: 8, maximum: 24 }, if: -> { self.salt.nil? }
  validates :display_name, length: { maximum: 30 }, format: { without: /@/ }
  validates :about_me, length: { maximum: 150 }

  before_save :hash_password, if: -> { self.salt.nil? }

  # Authenticates the password included with the password of this user
  def authenticate(password)
    password << self.salt
    password = Digest::SHA256.hexdigest password
    if password == self.password
      true
    else
      false
    end
  end

  # Returns the name that should be displayed
  def name
     if display_name.blank?
       '@' << self.username
     else
       # Return complete name if display name is not unique, to remove ambiguity
       if User.where(display_name: self.display_name).size > 1
         complete_name
       else
         self.display_name
       end
     end
  end

  # Like above, but it will always include the username
  def complete_name
    if display_name.blank?
      name
    else
      self.display_name + ' (@' + self.username + ')'
    end
  end

  # Returns the url that should display the avatar
  def avatar_url
    'avatars/' + self.avatar
  end

  # Returns the number of posts this user has made
  def post_count
     posts.size
  end

  # Returns the number of comments this user has made
  def comment_count
     comments.size
  end

  # Returns the number of replies this user has made
  def reply_count
     replies.size
  end


  # Returns the rank of the user as a readable string
  def rank_name
    self.rank.humanize
  end

  # Same as the above method, but shortened if possible
  def rank_name_short
    if self.rank == 'administrator'
      'Admin'
    elsif self.rank == 'moderator'
      'Mod'
    else
      rank_name
    end
  end

  # Similar to the above method, but this will also label the user as OP if applicable
  def rank_name_op(op)
    if self == op
      rank_name_short + ' (OP)'
    else
      rank_name_short
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
