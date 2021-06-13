class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :replies, dependent: :destroy

  validates :content, length: { maximum: 10000}, presence: true
end
