class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, length: { maximum: 50}, presence: true
  validates :content, length: { maximum: 10000}, presence: true
end
