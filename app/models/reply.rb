class Reply < ApplicationRecord
  belongs_to :comment
  belongs_to :user

  validates :content, length: { maximum: 10000}, presence: true
end
