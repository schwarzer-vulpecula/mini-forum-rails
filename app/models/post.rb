class Post < ApplicationRecord
  validates :title, length: { maximum: 50}, presence: true
  validates :content, presence: true
end
