class Review < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :rating, inclusion: { in: 1..5 }
  validates :comment, presence: true
end
