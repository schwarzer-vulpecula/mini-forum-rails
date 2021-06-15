class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, length: { maximum: 50 }, presence: true
  validates :content, length: { maximum: 40000 }, presence: true

=begin
  Tells the post to update its recent_activity value with the current time.
  Because the update_at is supposed to represent when the post's content is actually updated,
  this need to be done differently.
=end
  def touch_recent
    self.recent_activity = Time.now
    self.save(touch: false)
  end

  # Returns posts with a title matching the search query
  def self.search(search)
    if search.blank?
      Post.all
    else
      Post.where("title LIKE ?", "%#{search}%")
    end
  end
end
