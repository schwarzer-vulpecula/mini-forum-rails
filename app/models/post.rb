class Post < ApplicationRecord
  belongs_to :user

  validates :title, length: { maximum: 50}, presence: true
  validates :content, presence: true
end
